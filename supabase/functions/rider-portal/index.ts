/**
 * Rider portal — server-side access to `riders` / `orders` for non–Supabase-Auth riders.
 *
 * Future (recommended): migrate riders to Supabase Auth (magic link / OTP), store `riders.auth_user_id`,
 * then drop email-in-body verification and use RLS `auth.uid()` + JWT for realtime.
 */
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient, type SupabaseClient } from 'https://esm.sh/@supabase/supabase-js@2'
import bcrypt from 'https://esm.sh/bcryptjs@2.4.3'
import { sendSms, normaliseGhanaPhone } from '../_shared/arkesel.ts'

// Notify a vendor (business) by SMS about a rider's response to their assignment.
async function notifyVendor(sb: SupabaseClient, orderId: string, message: (ref: string) => string) {
  try {
    const { data: ord } = await sb.from('orders').select('business_id, business_order_ref').eq('id', orderId).maybeSingle()
    const bizId = (ord as { business_id?: string | null } | null)?.business_id
    if (!bizId) return
    const { data: biz } = await sb.from('businesses').select('phone').eq('id', bizId).maybeSingle()
    const phone = normaliseGhanaPhone(String((biz as { phone?: string } | null)?.phone ?? ''))
    if (phone) await sendSms(phone, message(String((ord as { business_order_ref?: string } | null)?.business_order_ref ?? '').trim()))
  } catch (e) { console.error('notifyVendor', e) }
}

/**
 * Uber/Bolt-style auto-dispatch for errands & pickups (dornye `pickup_delivery_orders`).
 * Gathers the currently online riders with live coordinates and hands them to the dornye
 * bridge, which (where the orders live) expires stale 2-minute offers, rolls them to the
 * next nearest rider, and offers un-assigned orders to the nearest online rider.
 * Storefront/vendor orders are intentionally excluded — the vendor preps and assigns those.
 */
async function runAutoDispatch(sb: SupabaseClient) {
  try {
    const { data: ridersRows } = await sb.from('riders')
      .select('id, name, phone, current_lat, current_lng, city')
      .eq('is_online', true).not('current_lat', 'is', null).not('current_lng', 'is', null)
    const riders = ((ridersRows ?? []) as Record<string, any>[]).map((r) => ({
      id: r.id, name: r.name ?? null, phone: r.phone ?? null,
      lat: Number(r.current_lat), lng: Number(r.current_lng), city: r.city ?? null,
    }))
    if (riders.length === 0) return
    await fetchdornyeBridge('auto_dispatch_pickups', { riders })
  } catch (e) { console.error('runAutoDispatch', e) }
}

const SESSION_COOKIE_NAME = 'orderzone_rider_session'
const SESSION_MAX_AGE = 60 * 60 * 24 * 7 // 7 days
const RESET_TOKEN_TTL_MS = 30 * 60 * 1000 // 30 minutes
const OTP_CODE_TTL_MS = 15 * 60 * 1000 // 15 minutes
const SESSION_SECRET = (Deno.env.get('RIDER_PORTAL_SESSION_SECRET') ?? Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '').trim()

function isTrustedOrigin(origin: string): boolean {
  try {
    const url = new URL(origin)
    const hostname = url.hostname
    // Private LAN IPs so the app works when tested from a phone on the same network in dev.
    const isPrivateLan = /^192\.168\.\d{1,3}\.\d{1,3}$/.test(hostname)
      || /^10\.\d{1,3}\.\d{1,3}\.\d{1,3}$/.test(hostname)
      || /^172\.(1[6-9]|2\d|3[0-1])\.\d{1,3}\.\d{1,3}$/.test(hostname)
    return (
      url.protocol === 'https:' || hostname === 'localhost' || hostname === '127.0.0.1' || isPrivateLan
    )
  } catch {
    return false
  }
}

function buildCorsHeaders(req: Request): Record<string, string> {
  const origin = req.headers.get('origin') ?? ''
  const allowedOrigin = isTrustedOrigin(origin) ? origin : 'null'
  return {
    'Access-Control-Allow-Origin': allowedOrigin,
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
    'Access-Control-Allow-Credentials': 'true',
    Vary: 'Origin',
  }
}

/** Sliding-window rate limit per client IP (best-effort; resets per isolate). */
const hitTimestamps = new Map<string, number[]>()
/** 🔐 CSRF token storage (in-memory cache, limited to recent sessions) */
const csrfTokenCache = new Map<string, { hash: string; expiresAt: number }>()

function clientIp(req: Request): string {
  const xff = req.headers.get('x-forwarded-for')
  if (xff) return xff.split(',')[0]?.trim() ?? 'unknown'
  return req.headers.get('cf-connecting-ip') ?? 'unknown'
}

function generateCSRFToken(): string {
  const array = new Uint8Array(32)
  crypto.getRandomValues(array)
  return Array.from(array, byte => byte.toString(16).padStart(2, '0')).join('')
}

function storeCSRFToken(token: string): void {
  try {
    const tokenHash = new TextEncoder().encode(token)
    const hashKey = btoa(String.fromCharCode(...new Uint8Array(tokenHash.slice(0, 16))))
    const expiresAt = Date.now() + 3600000 // 1 hour
    csrfTokenCache.set(hashKey, { hash: token, expiresAt })
    // Clean expired tokens
    for (const [key, val] of csrfTokenCache.entries()) {
      if (val.expiresAt < Date.now()) csrfTokenCache.delete(key)
    }
  } catch {
    // Ignore errors in CSRF caching
  }
}

function validateCSRFToken(token: string): boolean {
  if (!token || typeof token !== 'string') return false
  try {
    const tokenHash = new TextEncoder().encode(token)
    const hashKey = btoa(String.fromCharCode(...new Uint8Array(tokenHash.slice(0, 16))))
    const stored = csrfTokenCache.get(hashKey)
    if (!stored || stored.expiresAt < Date.now()) return false
    return stored.hash === token
  } catch {
    return false
  }
}

function sanitizeUserString(value: string, maxLength = 200): string {
  if (typeof value !== 'string') return ''
  let result = value.replace(/[-<>"']/g, '')
  result = result.trim()
  if (result.length > maxLength) result = result.substring(0, maxLength)
  return result
}

function isValidEmail(email: string): boolean {
  if (!email || typeof email !== 'string') return false
  const normalized = email.trim().toLowerCase()
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  return emailRegex.test(normalized) && normalized.length <= 254
}

function isValidOtpCode(code: string): boolean {
  return typeof code === 'string' && /^[0-9]{6}$/.test(code.trim())
}

function generateOtpCode(): string {
  const array = new Uint8Array(3)
  crypto.getRandomValues(array)
  const number = (array[0] << 16) | (array[1] << 8) | array[2]
  return String(100000 + (number % 900000)).padStart(6, '0')
}

function bytesToBase64(bytes: Uint8Array): string {
  let binary = ''
  for (const byte of bytes) {
    binary += String.fromCharCode(byte)
  }
  return btoa(binary)
}

function base64ToBytes(base64: string): Uint8Array {
  const binary = atob(base64)
  const bytes = new Uint8Array(binary.length)
  for (let i = 0; i < binary.length; i++) {
    bytes[i] = binary.charCodeAt(i)
  }
  return bytes
}

async function getSessionSigner(): Promise<CryptoKey> {
  if (!SESSION_SECRET) {
    throw new Error('Session secret is not configured')
  }
  return crypto.subtle.importKey(
    'raw',
    new TextEncoder().encode(SESSION_SECRET),
    { name: 'HMAC', hash: 'SHA-256' },
    false,
    ['sign', 'verify'],
  )
}

async function signPayload(payload: Uint8Array): Promise<Uint8Array> {
  const key = await getSessionSigner()
  const signature = await crypto.subtle.sign('HMAC', key, payload)
  return new Uint8Array(signature)
}

async function verifySignature(payload: Uint8Array, signature: Uint8Array): Promise<boolean> {
  const key = await getSessionSigner()
  return crypto.subtle.verify('HMAC', key, signature, payload)
}

function parseCookies(cookieHeader: string | null): Record<string, string> {
  const cookies: Record<string, string> = {}
  if (!cookieHeader) return cookies
  for (const pair of cookieHeader.split(';')) {
    const [name, ...rest] = pair.trim().split('=')
    if (!name) continue
    cookies[name] = rest.join('=').trim()
  }
  return cookies
}

function buildSetCookieHeader(value: string): string {
  const parts = [
    `${SESSION_COOKIE_NAME}=${value}`,
    'HttpOnly',
    'Secure',
    'SameSite=Strict',
    'Path=/',
    `Max-Age=${SESSION_MAX_AGE}`,
  ]
  return parts.join('; ')
}

function buildClearCookieHeader(): string {
  return `${SESSION_COOKIE_NAME}=; HttpOnly; Secure; SameSite=Strict; Path=/; Max-Age=0`
}

async function createSessionCookieValue(session: {
  id: string
  email: string
  name: string
  profileImageUrl?: string | null
  exp: number
}): Promise<string> {
  const payload = JSON.stringify(session)
  const payloadBytes = new TextEncoder().encode(payload)
  const signature = await signPayload(payloadBytes)
  return `${bytesToBase64(payloadBytes)}.${bytesToBase64(signature)}`
}

async function parseSessionCookie(cookieHeader: string | null): Promise<{
  id: string
  email: string
  name: string
  profileImageUrl?: string | null
  exp: number
} | null> {
  try {
    const cookies = parseCookies(cookieHeader)
    const token = cookies[SESSION_COOKIE_NAME]
    if (!token) return null
    const [payloadB64, signatureB64] = token.split('.')
    if (!payloadB64 || !signatureB64) return null

    const payloadBytes = base64ToBytes(payloadB64)
    const signatureBytes = base64ToBytes(signatureB64)
    if (!(await verifySignature(payloadBytes, signatureBytes))) return null

    const session = JSON.parse(new TextDecoder().decode(payloadBytes)) as {
      id: string
      email: string
      name: string
      profileImageUrl?: string | null
      exp: number
    }
    if (!session.id || !session.email || typeof session.exp !== 'number') return null
    if (session.exp < Date.now()) return null
    return session
  } catch {
    return null
  }
}

/** Verifies an HMAC-signed session token (same format as the cookie) passed in the request body. */
async function verifySessionToken(token: string | undefined): Promise<{
  id: string
  email: string
  name: string
  profileImageUrl?: string | null
  exp: number
} | null> {
  if (!token || typeof token !== 'string') return null
  try {
    const [payloadB64, signatureB64] = token.split('.')
    if (!payloadB64 || !signatureB64) return null
    const payloadBytes = base64ToBytes(payloadB64)
    const signatureBytes = base64ToBytes(signatureB64)
    if (!(await verifySignature(payloadBytes, signatureBytes))) return null
    const session = JSON.parse(new TextDecoder().decode(payloadBytes)) as {
      id: string; email: string; name: string; profileImageUrl?: string | null; exp: number
    }
    if (!session.id || !session.email || typeof session.exp !== 'number') return null
    if (session.exp < Date.now()) return null
    return session
  } catch {
    return null
  }
}

function rateAllowed(ip: string): boolean {
  const max = parseInt(Deno.env.get('RIDER_PORTAL_MAX_PER_MINUTE') ?? '90', 10)
  const windowMs = 60_000
  const now = Date.now()
  const list = (hitTimestamps.get(ip) ?? []).filter((t) => now - t < windowMs)
  if (list.length >= max) return false
  list.push(now)
  hitTimestamps.set(ip, list)
  return true
}

function json(status: number, body: Record<string, unknown>) {
  return new Response(JSON.stringify(body), {
    status,
    headers: {
      'Content-Type': 'application/json',
    },
  })
}

/** Always 200 so `supabase.functions.invoke` returns parsed JSON in `data` (reliable client handling). */
function ok<T extends Record<string, unknown>>(data: T) {
  return json(200, { ok: true, ...data })
}

function fail(error: string, extra?: Record<string, unknown>) {
  return json(200, { ok: false, error, ...extra })
}

function makeResponder(req: Request) {
  return {
    json(status: number, body: Record<string, unknown>, extraHeaders: Record<string, string> = {}) {
      return new Response(JSON.stringify(body), {
        status,
        headers: {
          ...buildCorsHeaders(req),
          'Content-Type': 'application/json',
          ...extraHeaders,
        },
      })
    },
    ok<T extends Record<string, unknown>>(data: T, extraHeaders: Record<string, string> = {}) {
      return new Response(JSON.stringify({ ok: true, ...data }), {
        status: 200,
        headers: {
          ...buildCorsHeaders(req),
          'Content-Type': 'application/json',
          ...extraHeaders,
        },
      })
    },
    fail(error: string, extra?: Record<string, unknown>, extraHeaders: Record<string, string> = {}) {
      return new Response(JSON.stringify({ ok: false, error, ...extra }), {
        status: 200,
        headers: {
          ...buildCorsHeaders(req),
          'Content-Type': 'application/json',
          ...extraHeaders,
        },
      })
    },
  }
}

function normEmail(s: string) {
  return s.trim().toLowerCase()
}

function escapeHtml(s: string): string {
  return s
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;')
}

function randomResetToken(): string {
  return crypto.randomUUID().replace(/-/g, '') + crypto.randomUUID().replace(/-/g, '')
}

async function sendRiderResetEmail(
  to: string,
  riderName: string,
  resetUrl: string,
  otpCode: string,
): Promise<{ ok: true } | { ok: false; error: string }> {
  const resendKey = Deno.env.get('RESEND_API_KEY') ?? ''
  const fromEmail = Deno.env.get('FROM_EMAIL') ?? ''
  if (!resendKey || !fromEmail) return { ok: false, error: 'Email is not configured on the server (RESEND_API_KEY / FROM_EMAIL).' }
  const safeName = escapeHtml(riderName)
  const safeResetUrl = escapeHtml(resetUrl)
  const safeOtpCode = escapeHtml(otpCode)
  const html = `
<div style="font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial;line-height:1.5">
  <h2 style="margin:0 0 8px">Hi ${safeName},</h2>
  <p style="margin:0 0 12px">You requested a rider portal password reset. Use the code below and click the link to set a new password.</p>
  <p style="margin:0 0 12px"><strong>Verification code:</strong> ${safeOtpCode}</p>
  <p style="margin:0 0 12px"><a href="${safeResetUrl}">${safeResetUrl}</a></p>
  <p style="margin:0 0 12px">The code expires in 15 minutes and the reset link expires in 30 minutes.</p>
  <p style="margin:0;font-size:12px;opacity:.75">If you did not request this, you can ignore this email.</p>
</div>`
  const resp = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: { Authorization: `Bearer ${resendKey}`, 'Content-Type': 'application/json' },
    body: JSON.stringify({
      from: fromEmail,
      to: [to],
      subject: 'dornye — set your rider portal password',
      html,
    }),
  })
  if (!resp.ok) {
    const txt = await resp.text()
    return { ok: false, error: `Email failed: ${txt.slice(0, 200)}` }
  }
  return { ok: true }
}

async function sendRiderOtpEmail(
  to: string,
  riderName: string,
  otpCode: string,
): Promise<{ ok: true } | { ok: false; error: string }> {
  const resendKey = Deno.env.get('RESEND_API_KEY') ?? ''
  const fromEmail = Deno.env.get('FROM_EMAIL') ?? ''
  if (!resendKey || !fromEmail) return { ok: false, error: 'Email is not configured on the server.' }
  const safeName = escapeHtml(riderName)
  const safeCode = escapeHtml(otpCode)
  const html = `
<div style="font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial;line-height:1.5;max-width:480px">
  <h2 style="margin:0 0 8px">Hi ${safeName},</h2>
  <p style="margin:0 0 12px">Your dornye rider portal verification code is:</p>
  <div style="font-size:36px;font-weight:800;letter-spacing:8px;color:#ea580c;margin:20px 0;font-family:monospace">${safeCode}</div>
  <p style="margin:0 0 12px;color:#555">Enter this code on the password setup page. It expires in 15 minutes.</p>
  <p style="margin:0;font-size:12px;opacity:.7">If you did not request this, ignore this email.</p>
</div>`
  const resp = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: { Authorization: `Bearer ${resendKey}`, 'Content-Type': 'application/json' },
    body: JSON.stringify({ from: fromEmail, to: [to], subject: 'dornye — rider portal verification code', html }),
  })
  if (!resp.ok) {
    const txt = await resp.text()
    return { ok: false, error: `Email failed: ${txt.slice(0, 200)}` }
  }
  return { ok: true }
}

async function sendRiderWelcomeEmail(
  to: string,
  riderName: string,
  loginUrl: string,
): Promise<{ ok: true } | { ok: false; error: string }> {
  const resendKey = Deno.env.get('RESEND_API_KEY') ?? ''
  const fromEmail = Deno.env.get('FROM_EMAIL') ?? ''
  if (!resendKey || !fromEmail) return { ok: false, error: 'Email is not configured on the server (RESEND_API_KEY / FROM_EMAIL).' }
  const safeName = escapeHtml(riderName)
  const safeLoginUrl = escapeHtml(loginUrl)
  const html = `
<div style="font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial;line-height:1.5">
  <h2 style="margin:0 0 8px">Congratulations ${safeName},</h2>
  <p style="margin:0 0 12px">You are now a rider for <strong>dornye</strong>.</p>
  <p style="margin:0 0 12px">Click this link to sign in: <a href="${safeLoginUrl}">${safeLoginUrl}</a></p>
  <p style="margin:0;font-size:12px;opacity:.75">Welcome to the fleet.</p>
</div>`
  const resp = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: { Authorization: `Bearer ${resendKey}`, 'Content-Type': 'application/json' },
    body: JSON.stringify({
      from: fromEmail,
      to: [to],
      subject: 'Welcome to dornye rider portal',
      html,
    }),
  })
  if (!resp.ok) {
    const txt = await resp.text()
    return { ok: false, error: `Email failed: ${txt.slice(0, 200)}` }
  }
  return { ok: true }
}

/** Supabase insert/update errors may be non-Error objects without enumerable `message`. */
function formatDbErr(err: unknown): string {
  if (err == null || err === '') return ''
  if (typeof err === 'string') return err
  if (err instanceof Error) return err.message || ''
  if (typeof err === 'object') {
    const o = err as Record<string, unknown>
    const parts = [o.message, o.details, o.hint, o.code]
      .map((x) => (typeof x === 'string' && x.trim() ? x.trim() : ''))
      .filter(Boolean)
    if (parts.length) return parts.join(' — ')
    try {
      return JSON.stringify(err)
    } catch {
      return String(err)
    }
  }
  return String(err)
}

function formatdornyeBridgeError(raw: unknown): string {
  if (raw == null || raw === '') return 'dornye bridge error'
  if (typeof raw === 'string') return raw
  if (raw instanceof Error) return raw.message
  if (typeof raw === 'object') {
    const o = raw as Record<string, unknown>
    const msg = o.message ?? o.error_description
    if (typeof msg === 'string' && msg.trim()) return msg.trim()
    try {
      return JSON.stringify(raw)
    } catch {
      return String(raw)
    }
  }
  return String(raw)
}

/** Calls dornye `orderzone-bridge` (same secret as OrderZone admin uses). Optional: omit env to skip pickup features. */
async function fetchdornyeBridge<T>(action: string, payload: Record<string, unknown>): Promise<T> {
  const url = Deno.env.get('dornye_BRIDGE_URL')?.trim()
  const secret = Deno.env.get('dornye_BRIDGE_SECRET')?.trim()
  if (!url || !secret) {
    throw new Error('dornye_BRIDGE_URL / dornye_BRIDGE_SECRET not set')
  }
  const res = await fetch(url, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'x-bridge-secret': secret,
    },
    body: JSON.stringify({ action, payload }),
  })
  const text = await res.text()
  let parsed: { data?: T; error?: unknown }
  try {
    parsed = text.trim() ? (JSON.parse(text) as { data?: T; error?: unknown }) : {}
  } catch {
    throw new Error(text.slice(0, 280) || res.statusText || 'Invalid dornye bridge response')
  }
  if (!res.ok) {
    throw new Error(formatdornyeBridgeError(parsed.error ?? res.statusText))
  }
  if (parsed.error != null && parsed.error !== '') {
    throw new Error(formatdornyeBridgeError(parsed.error))
  }
  return parsed.data as T
}

type RiderAuthOpts = {
  tokenSession?: { id: string; email: string; name: string; exp: number } | null
  requireToken?: boolean
}

/**
 * Authorizes a rider request. Strong path: a valid HMAC-signed session token whose id
 * matches riderId (cannot be forged without the server secret). Legacy fallback: email
 * matches the rider row — kept for transition and disabled when requireToken is set
 * (RIDER_REQUIRE_SESSION_TOKEN=true), which then demands a valid token.
 */
async function assertRiderEmail(
  sb: SupabaseClient,
  riderId: string,
  email: string,
  opts?: RiderAuthOpts,
): Promise<
  { ok: true; rider: { id: string; name: string; email: string | null; phone: string | null } } | { ok: false; error: string }
> {
  const tokenOk = !!(opts?.tokenSession && riderId && opts.tokenSession.id === riderId)

  if (!tokenOk && opts?.requireToken) {
    return { ok: false, error: 'Your session has expired. Please sign in again.' }
  }

  const { data: r, error } = await sb.from('riders').select('id,name,email,phone').eq('id', riderId).maybeSingle()
  if (error) {
    console.error('riders lookup', error)
    return { ok: false, error: 'Lookup failed' }
  }
  if (!r?.id) return { ok: false, error: 'Rider not found' }

  // Token verified the identity cryptographically — no need to re-check the email.
  if (!tokenOk) {
    const want = normEmail(email)
    if (!want) return { ok: false, error: 'email required' }
    const got = r.email ? normEmail(r.email) : ''
    if (!got || got !== want) return { ok: false, error: 'Forbidden' }
  }

  const phone = r.phone != null && String(r.phone).trim() ? String(r.phone).trim() : null
  return { ok: true, rider: { id: r.id, name: r.name, email: r.email, phone } }
}

async function resolveStaffUserId(sb: SupabaseClient, authUid: string, authEmail: string): Promise<string> {
  let staffUserId = authUid
  if (authEmail) {
    const { data: pu } = await sb.from('users').select('id').ilike('email', authEmail).maybeSingle()
    const row = pu as { id?: string } | null
    if (row?.id) staffUserId = row.id
  }
  return staffUserId
}

/**
 * Only an explicitly listed platform team member may manage fleet rider data.
 */
async function assertDashboardFleetAdmin(
  sb: SupabaseClient,
  authHeader: string,
): Promise<{ ok: true; authUid: string; staffUserId: string } | { ok: false; error: string }> {
  if (!authHeader.startsWith('Bearer ')) return { ok: false, error: 'Unauthorized' }
  const jwt = authHeader.slice('Bearer '.length)
  const { data: userData, error: authErr } = await sb.auth.getUser(jwt)
  if (authErr || !userData?.user?.id) return { ok: false, error: 'Unauthorized' }
  const portal = (userData.user.user_metadata as Record<string, unknown> | undefined)?.portal
  if (portal === 'business') {
    return { ok: false, error: 'Business portal accounts cannot manage fleet rider passwords.' }
  }
  const authUid = userData.user.id
  const authEmail = userData.user.email ? normEmail(userData.user.email) : ''
  const staffUserId = await resolveStaffUserId(sb, authUid, authEmail)

  const { data: rowStaff } = await sb.from('admin_team_members').select('id').eq('user_id', staffUserId).maybeSingle()
  const { data: rowAuth } =
    staffUserId === authUid
      ? { data: null as { id: string } | null }
      : await sb.from('admin_team_members').select('id').eq('user_id', authUid).maybeSingle()
  const onTeam = !!(rowStaff as { id?: string } | null)?.id || !!(rowAuth as { id?: string } | null)?.id
  if (onTeam) return { ok: true, authUid, staffUserId }

  return { ok: false, error: 'You are not authorised to manage fleet rider data.' }
}

async function assertRiderOwnsOrder(
  sb: SupabaseClient,
  riderId: string,
  email: string,
  orderId: string,
  opts?: RiderAuthOpts,
): Promise<
  | { ok: true; rider: { id: string; name: string; email: string | null; phone: string | null } }
  | { ok: false; error: string }
> {
  const v = await assertRiderEmail(sb, riderId, email, opts)
  if (!v.ok) return v
  const { data: o, error } = await sb.from('orders').select('id,assigned_rider').eq('id', orderId).maybeSingle()
  if (error || !o) return { ok: false, error: 'Order not found' }
  if (o.assigned_rider !== riderId) return { ok: false, error: 'Not your order' }
  return { ok: true, rider: v.rider }
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', {
      headers: {
        ...buildCorsHeaders(req),
        'Content-Type': 'text/plain',
      },
    })
  }

  const { json, ok, fail } = makeResponder(req)

  if (req.method !== 'POST') {
    return json(405, { ok: false, error: 'Method not allowed' })
  }

  const ip = clientIp(req)
  if (!rateAllowed(ip)) {
    return json(429, { ok: false, error: 'Too many requests. Try again shortly.' })
  }

  const url = Deno.env.get('SUPABASE_URL') ?? ''
  const key = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
  if (!url || !key) return json(500, { ok: false, error: 'Server misconfigured' })

  const sb = createClient(url, key, { auth: { persistSession: false, autoRefreshToken: false } })

  let body: Record<string, unknown>
  try {
    body = (await req.json()) as Record<string, unknown>
  } catch {
    return fail('Invalid JSON')
  }

  const action = typeof body.action === 'string' ? body.action : ''

  // Cryptographic session proof (preferred over the legacy id+email check).
  const tokenSession = await verifySessionToken(typeof body.sessionToken === 'string' ? body.sessionToken : undefined)
  const requireToken = (Deno.env.get('RIDER_REQUIRE_SESSION_TOKEN') ?? '').trim().toLowerCase() === 'true'
  const riderAuthOpts: RiderAuthOpts = { tokenSession, requireToken }

  try {
    if (action === 'login') {
      const email = typeof body.email === 'string' ? body.email : ''
      const password = typeof body.password === 'string' ? body.password : ''
      const want = normEmail(email)
      if (!want) return fail('email required')
      if (!password.trim()) return fail('password required')
      const { data: r, error } = await sb
        .from('riders')
        .select('id,name,email,portal_password_hash,profile_image_url')
        .ilike('email', want)
        .limit(1)
        .maybeSingle()
      if (error) {
        console.error('login', error)
        return fail('Lookup failed')
      }
      if (!r?.id) return fail('Rider not found')
      const row = r as { id: string; name: string; email: string | null; portal_password_hash?: string | null }
      const hash = row.portal_password_hash != null ? String(row.portal_password_hash).trim() : ''
      if (!hash) {
        return fail('Rider password is not set yet. Ask admin to set your portal password.')
      }
      if (!bcrypt.compareSync(password, hash)) {
        return fail('Invalid email or password')
      }

      const session = {
        id: row.id,
        email: row.email ?? '',
        name: row.name,
        profileImageUrl: (row as { profile_image_url?: string | null }).profile_image_url ?? null,
        exp: Date.now() + SESSION_MAX_AGE * 1000,
      }
      const cookieValue = await createSessionCookieValue(session)
      return ok(
        {
          data: {
            id: row.id,
            name: row.name,
            email: row.email,
            profileImageUrl: (row as { profile_image_url?: string | null }).profile_image_url ?? null,
            // Cryptographic session proof the client sends back on every request.
            sessionToken: cookieValue,
          },
        },
        { 'Set-Cookie': buildSetCookieHeader(cookieValue) },
      )
    }

    if (action === 'verify_session') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      if (riderId && email) {
        const v = await assertRiderEmail(sb, riderId, email, riderAuthOpts)
        if (!v.ok) return fail(v.error)
        // (Re)issue a signed token so the client always has fresh cryptographic proof.
        // While requireToken is off, this also bootstraps a token for legacy sessions so
        // enabling enforcement later does not log anyone out.
        const freshToken = await createSessionCookieValue({
          id: v.rider.id,
          email: v.rider.email ?? email,
          name: v.rider.name,
          profileImageUrl: null,
          exp: Date.now() + SESSION_MAX_AGE * 1000,
        })
        return ok({ data: { id: v.rider.id, email: v.rider.email, name: v.rider.name, profileImageUrl: null, sessionToken: freshToken } })
      }
      const session = await parseSessionCookie(req.headers.get('cookie'))
      if (!session) return fail('Not authenticated')
      return ok({ data: session })
    }

    if (action === 'logout') {
      return ok({ data: { loggedOut: true } }, { 'Set-Cookie': buildClearCookieHeader() })
    }

    if (action === 'set_availability') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      const v = await assertRiderEmail(sb, riderId, email, riderAuthOpts)
      if (!v.ok) return fail(v.error)
      const online = Boolean(body.online)
      const { error: upErr } = await sb
        .from('riders')
        .update({ is_online: online, ...(online ? { last_online_at: new Date().toISOString() } : {}), updated_at: new Date().toISOString() })
        .eq('id', v.rider.id)
      if (upErr) return fail(upErr.message)
      return ok({ data: { is_online: online } })
    }

    if (action === 'rider_economy') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      const v = await assertRiderEmail(sb, riderId, email, riderAuthOpts)
      if (!v.ok) return fail(v.error)
      try {
        const data = await fetchdornyeBridge('rider_economy_summary', { orderzone_rider_id: v.rider.id })
        return ok({ data: (data ?? {}) as Record<string, unknown> })
      } catch (e) {
        console.error('rider_economy', e)
        return fail(e instanceof Error ? e.message : 'Could not load earnings')
      }
    }

    if (action === 'rider_redeem') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      const v = await assertRiderEmail(sb, riderId, email, riderAuthOpts)
      if (!v.ok) return fail(v.error)
      const reward = typeof body.reward === 'string' ? body.reward : ''
      const item_name = typeof body.item_name === 'string' ? body.item_name : ''
      try {
        const data = await fetchdornyeBridge('rider_redeem_points', { orderzone_rider_id: v.rider.id, reward, item_name })
        return ok({ data: (data ?? {}) as Record<string, unknown> })
      } catch (e) {
        return fail(e instanceof Error ? e.message : 'Redeem failed')
      }
    }

    if (action === 'rider_settlement_pay') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      const v = await assertRiderEmail(sb, riderId, email, riderAuthOpts)
      if (!v.ok) return fail(v.error)
      const week_start = typeof body.week_start === 'string' ? body.week_start : ''
      const momo_ref = typeof body.momo_ref === 'string' ? body.momo_ref : ''
      if (!week_start) return fail('week_start required')
      try {
        await fetchdornyeBridge('rider_mark_settlement_paid', { orderzone_rider_id: v.rider.id, week_start, momo_ref })
        return ok({ data: {} })
      } catch (e) {
        console.error('rider_settlement_pay', e)
        return fail(e instanceof Error ? e.message : 'Could not record payment')
      }
    }

    if (action === 'rider_change_password') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      const v = await assertRiderEmail(sb, riderId, email, riderAuthOpts)
      if (!v.ok) return fail(v.error)
      const currentPassword = typeof body.currentPassword === 'string' ? body.currentPassword : ''
      const newPassword = typeof body.newPassword === 'string' ? body.newPassword : ''
      if (newPassword.length < 6) return fail('New password must be at least 6 characters')
      const { data: r } = await sb.from('riders').select('portal_password_hash').eq('id', v.rider.id).maybeSingle()
      const hash = (r as { portal_password_hash?: string | null } | null)?.portal_password_hash ?? ''
      if (hash && !bcrypt.compareSync(currentPassword, String(hash))) return fail('Current password is incorrect')
      const newHash = bcrypt.hashSync(newPassword, 10)
      const { error: upErr } = await sb.from('riders').update({ portal_password_hash: newHash, updated_at: new Date().toISOString() }).eq('id', v.rider.id)
      if (upErr) return fail(upErr.message)
      return ok({ data: { ok: true } })
    }

    if (action === 'set_rider_birthday') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      const v = await assertRiderEmail(sb, riderId, email, riderAuthOpts)
      if (!v.ok) return fail(v.error)
      const birthday = typeof body.birthday === 'string' ? body.birthday.slice(0, 10) : ''
      if (!/^\d{4}-\d{2}-\d{2}$/.test(birthday)) return fail('Invalid date')
      const { error: upErr } = await sb.from('riders').update({ birthday, updated_at: new Date().toISOString() }).eq('id', v.rider.id)
      if (upErr) return fail(upErr.message)
      return ok({ data: { ok: true } })
    }

    if (action === 'update_rider_profile') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      const v = await assertRiderEmail(sb, riderId, email, riderAuthOpts)
      if (!v.ok) return fail(v.error)
      const name = typeof body.name === 'string' ? body.name.trim() : ''
      const phone = typeof body.phone === 'string' ? body.phone.trim() : ''
      if (!name) return fail('Name is required')
      const update: Record<string, unknown> = { name, updated_at: new Date().toISOString() }
      if (phone) update.phone = phone
      const { error: upErr } = await sb.from('riders').update(update).eq('id', v.rider.id)
      if (upErr) return fail(upErr.message)
      return ok({ data: { name, phone } })
    }

    if (action === 'request_inventory') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      const v = await assertRiderEmail(sb, riderId, email, riderAuthOpts)
      if (!v.ok) return fail(v.error)
      const itemName = typeof body.item_name === 'string' ? body.item_name.trim() : ''
      const note = typeof body.note === 'string' ? body.note.trim() : ''
      if (!itemName) return fail('item_name required')
      const { error: insErr } = await sb.from('rider_inventory_requests').insert({ rider_id: v.rider.id, item_name: itemName, note: note || null })
      if (insErr) return fail(insErr.message)
      return ok({ data: { ok: true } })
    }

    if (action === 'cancel_inventory_request') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      const v = await assertRiderEmail(sb, riderId, email, riderAuthOpts)
      if (!v.ok) return fail(v.error)
      const requestId = typeof body.requestId === 'string' ? body.requestId : ''
      if (!requestId) return fail('requestId required')
      // Only the owning rider may cancel, and only while still pending.
      const { error: delErr } = await sb.from('rider_inventory_requests').delete().eq('id', requestId).eq('rider_id', v.rider.id).eq('status', 'pending')
      if (delErr) return fail(delErr.message)
      return ok({ data: { ok: true } })
    }

    if (action === 'update_profile_image') {
      const session = await parseSessionCookie(req.headers.get('cookie'))
      if (!session) return fail('Not authenticated')
      const imageUrl = typeof body.imageUrl === 'string' ? body.imageUrl.trim() : ''
      if (!imageUrl) return fail('imageUrl required')
      const { error: uErr } = await sb
        .from('riders')
        .update({ profile_image_url: imageUrl, updated_at: new Date().toISOString() })
        .eq('id', session.id)
      if (uErr) return fail(formatDbErr(uErr))
      return ok({ data: { profileImageUrl: imageUrl } })
    }

    if (action === 'submit_support') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      const v = await assertRiderEmail(sb, riderId, email, riderAuthOpts)
      if (!v.ok) return fail(v.error)
      const message = typeof body.message === 'string' ? body.message.trim() : ''
      const category = typeof body.category === 'string' ? body.category.trim() : 'general'
      if (!message) return fail('message required')
      const { error: iErr } = await sb.from('rider_support_tickets').insert({
        rider_id: v.rider.id,
        rider_name: v.rider.name,
        message,
        category,
        status: 'open',
        created_at: new Date().toISOString(),
      })
      if (iErr) return fail(formatDbErr(iErr))
      return ok({ data: { submitted: true } })
    }

    if (action === 'list_support_tickets') {
      // Admin action: no session required (caller authenticated via admin check in dornye-proxy or direct)
      const { data, error } = await sb
        .from('rider_support_tickets')
        .select('*')
        .order('created_at', { ascending: false })
        .limit(200)
      if (error) return fail(formatDbErr(error))
      return ok({ data })
    }

    if (action === 'close_support_ticket') {
      const id = typeof body.id === 'string' ? body.id : ''
      if (!id) return fail('id required')
      const { error } = await sb.from('rider_support_tickets').update({ status: 'closed', resolved_at: new Date().toISOString() }).eq('id', id)
      if (error) return fail(formatDbErr(error))
      return ok({ data: { closed: true } })
    }

    if (action === 'request_rider_password_reset') {
      const email = typeof body.email === 'string' ? normEmail(body.email) : ''
      if (!email || !email.includes('@')) return fail('email required')
      const { data: r, error: rErr } = await sb
        .from('riders')
        .select('id,name,email')
        .ilike('email', email)
        .limit(1)
        .maybeSingle()
      if (rErr) return fail(formatDbErr(rErr))
      // Avoid user enumeration.
      if (!r?.id || !r.email) return ok({ data: { sent: true } })
      const token = randomResetToken()
      const otp = generateOtpCode()
      // 🔐 SECURITY: Hash token and OTP before storing (prevents DB breach from exposing all valid secrets)
      const tokenHash = bcrypt.hashSync(token, 10)
      const otpHash = bcrypt.hashSync(otp, 10)
      const expiresAt = new Date(Date.now() + RESET_TOKEN_TTL_MS).toISOString()
      const otpExpiresAt = new Date(Date.now() + OTP_CODE_TTL_MS).toISOString()
      const { error: uErr } = await sb
        .from('riders')
        .update({
          portal_reset_token: tokenHash,
          portal_reset_expires_at: expiresAt,
          portal_reset_otp_hash: otpHash,
          portal_reset_otp_expires_at: otpExpiresAt,
          updated_at: new Date().toISOString(),
        })
        .eq('id', r.id)
      if (uErr) return fail(formatDbErr(uErr))
      const publicUrl = (Deno.env.get('ORDERZONE_PUBLIC_URL') ?? Deno.env.get('PUBLIC_SITE_URL') ?? 'https://dornyezone.dornye.com').replace(/\/+$/, '')
      const resetUrl = `${publicUrl}/rider/reset-password?token=${encodeURIComponent(token)}`
      const sent = await sendRiderResetEmail(email, String((r as { name?: string }).name ?? 'there'), resetUrl, otp)
      if (!sent.ok) return fail(sent.error)
      return ok({ data: { sent: true } })
    }

    if (action === 'rider_resend_otp') {
      const token = typeof body.token === 'string' ? body.token.trim() : ''
      if (!token) return fail('token required')

      const { data: riders, error: rErr } = await sb
        .from('riders')
        .select('id,name,email,portal_reset_token,portal_reset_expires_at')
        .limit(100)
      if (rErr) return fail(formatDbErr(rErr))

      let matchedRider = null
      if (riders) {
        for (const r of riders) {
          const stored = (r as { portal_reset_token?: string | null }).portal_reset_token
          if (stored && bcrypt.compareSync(token, stored)) { matchedRider = r; break }
        }
      }
      if (!matchedRider?.id) return fail('Invalid or expired reset link')
      const expires = (matchedRider as { portal_reset_expires_at?: string | null }).portal_reset_expires_at
      if (!expires || new Date(expires).getTime() < Date.now()) return fail('Reset link has expired. Request a new one.')

      const riderEmail = String((matchedRider as { email?: string | null }).email ?? '').trim().toLowerCase()
      const riderName = String((matchedRider as { name?: string | null }).name ?? 'there')
      if (!riderEmail.includes('@')) return fail('No email on file for this rider account')

      const otp = generateOtpCode()
      const otpHash = bcrypt.hashSync(otp, 10)
      const otpExpiresAt = new Date(Date.now() + OTP_CODE_TTL_MS).toISOString()
      const { error: upErr } = await sb
        .from('riders')
        .update({ portal_reset_otp_hash: otpHash, portal_reset_otp_expires_at: otpExpiresAt, updated_at: new Date().toISOString() })
        .eq('id', matchedRider.id)
      if (upErr) return fail(formatDbErr(upErr))

      await sendRiderOtpEmail(riderEmail, riderName, otp)

      // Return a masked email so the UI can show "Code sent to j***@gmail.com"
      const atIdx = riderEmail.indexOf('@')
      const local = riderEmail.slice(0, atIdx)
      const domain = riderEmail.slice(atIdx + 1)
      const maskedEmail = `${local.slice(0, 1)}${'*'.repeat(Math.min(local.length - 1, 3))}@${domain}`
      return ok({ data: { masked_email: maskedEmail } })
    }

    if (action === 'rider_reset_password') {
      const token = typeof body.token === 'string' ? body.token.trim() : ''
      const otpCode = typeof body.otp_code === 'string' ? body.otp_code.trim() : ''
      const newPassword = typeof body.new_password === 'string' ? body.new_password : ''
      if (!token) return fail('token required')
      if (!isValidOtpCode(otpCode)) return fail('OTP code is required')
      if (!newPassword || newPassword.length < 12) return fail('Password must be at least 12 characters')
      // Validate password complexity
      const hasUppercase = /[A-Z]/.test(newPassword)
      const hasLowercase = /[a-z]/.test(newPassword)
      const hasNumber = /[0-9]/.test(newPassword)
      const hasSpecial = /[@$!%*?&]/.test(newPassword)
      if (!hasUppercase || !hasLowercase || !hasNumber || !hasSpecial) {
        return fail('Password must contain uppercase, lowercase, number, and special character (@$!%*?&)')
      }
      // 🔐 SECURITY: Get all riders and check token hash (time-constant comparison)
      const { data: riders, error: rErr } = await sb
        .from('riders')
        .select('id,name,email,portal_reset_token,portal_reset_expires_at,portal_reset_otp_hash,portal_reset_otp_expires_at')
        .limit(100) // Get recent rows
      if (rErr) return fail(formatDbErr(rErr))
      
      let matchedRider = null
      if (riders) {
        for (const r of riders) {
          const stored = (r as { portal_reset_token?: string | null }).portal_reset_token
          if (stored && bcrypt.compareSync(token, stored)) {
            matchedRider = r
            break
          }
        }
      }
      
      if (!matchedRider?.id) return fail('Invalid or expired reset link')
      const expires = (matchedRider as { portal_reset_expires_at?: string | null }).portal_reset_expires_at
      if (!expires || new Date(expires).getTime() < Date.now()) return fail('Reset link expired')
      const otpHash = (matchedRider as { portal_reset_otp_hash?: string | null }).portal_reset_otp_hash
      const otpExpires = (matchedRider as { portal_reset_otp_expires_at?: string | null }).portal_reset_otp_expires_at
      if (!otpHash || !otpExpires || new Date(otpExpires).getTime() < Date.now()) {
        return fail('Verification code expired')
      }
      if (!bcrypt.compareSync(otpCode, otpHash)) {
        return fail('Invalid verification code')
      }
      const bcryptHash = bcrypt.hashSync(newPassword, 10)
      const { error: upErr } = await sb
        .from('riders')
        .update({
          portal_password_hash: bcryptHash,
          portal_reset_token: null,
          portal_reset_expires_at: null,
          portal_reset_otp_hash: null,
          portal_reset_otp_expires_at: null,
          updated_at: new Date().toISOString(),
        })
        .eq('id', matchedRider.id)
      if (upErr) return fail(formatDbErr(upErr))
      const publicUrl = (Deno.env.get('ORDERZONE_PUBLIC_URL') ?? Deno.env.get('PUBLIC_SITE_URL') ?? 'https://dornyezone.dornye.com').replace(/\/+$/, '')
      const loginUrl = `${publicUrl}/rider/login`
      const riderEmail = String((matchedRider as { email?: string | null }).email ?? '').trim().toLowerCase()
      const riderName = String((matchedRider as { name?: string | null }).name ?? 'Rider')
      if (riderEmail.includes('@')) {
        const welcome = await sendRiderWelcomeEmail(riderEmail, riderName, loginUrl)
        if (!welcome.ok) {
          console.warn('sendRiderWelcomeEmail:', welcome.error)
        }
      }
      // Fire SMS welcome — don't block response
      const { data: riderPhoneRow } = await sb.from('riders').select('phone').eq('id', matchedRider.id).maybeSingle()
      const riderPhone = riderPhoneRow?.phone != null ? String(riderPhoneRow.phone).trim() : ''
      if (riderPhone) {
        sendSms(riderPhone, `Hi ${riderName}, your dornye rider password is set! Log in here: ${loginUrl}`)
          .catch((e: unknown) => console.warn('SMS welcome failed:', e))
      }
      return ok({ data: { ok: true } })
    }

    if (action === 'admin_set_rider_portal_password') {
      const authHeader = req.headers.get('Authorization') ?? ''
      const gate = await assertDashboardFleetAdmin(sb, authHeader)
      if (!gate.ok) return fail(gate.error)
      const rider_id = typeof body.rider_id === 'string' ? body.rider_id : ''
      const new_password = typeof body.new_password === 'string' ? body.new_password : ''
      if (!rider_id) return fail('rider_id required')
      if (!new_password || new_password.length < 12) return fail('Password must be at least 12 characters')
      const bcryptHash = bcrypt.hashSync(new_password, 10)
      const { error: upErr } = await sb.from('riders').update({ portal_password_hash: bcryptHash }).eq('id', rider_id)
      if (upErr) {
        console.error('admin_set_rider_portal_password', upErr)
        return fail(formatDbErr(upErr))
      }
      return ok({ data: { ok: true } as Record<string, never> })
    }

    if (action === 'admin_email_rider_portal_notice') {
      const authHeader = req.headers.get('Authorization') ?? ''
      const gate = await assertDashboardFleetAdmin(sb, authHeader)
      if (!gate.ok) return fail(gate.error)
      const rider_id = typeof body.rider_id === 'string' ? body.rider_id : ''
      if (!rider_id) return fail('rider_id required')
      const { data: r, error: rErr } = await sb.from('riders').select('id,name,email,phone').eq('id', rider_id).maybeSingle()
      if (rErr || !r?.email) return fail('Rider has no email on file')
      const to = normEmail(String(r.email))
      if (!to.includes('@')) return fail('Invalid rider email')

      const publicUrl = (Deno.env.get('ORDERZONE_PUBLIC_URL') ?? Deno.env.get('PUBLIC_SITE_URL') ?? 'https://dornyezone.dornye.com')
        .replace(/\/+$/, '')
      // Generate raw token + OTP (pass raw values to email, store hashes in DB)
      const token = randomResetToken()
      const otp = generateOtpCode()
      const tokenHash = bcrypt.hashSync(token, 10)
      const otpHash = bcrypt.hashSync(otp, 10)
      const expiresAt = new Date(Date.now() + RESET_TOKEN_TTL_MS).toISOString()
      const otpExpiresAt = new Date(Date.now() + OTP_CODE_TTL_MS).toISOString()
      const { error: uErr } = await sb
        .from('riders')
        .update({
          portal_reset_token: tokenHash,
          portal_reset_expires_at: expiresAt,
          portal_reset_otp_hash: otpHash,
          portal_reset_otp_expires_at: otpExpiresAt,
          updated_at: new Date().toISOString(),
        })
        .eq('id', rider_id)
      if (uErr) return fail(formatDbErr(uErr))
      const resetUrl = `${publicUrl}/rider/reset-password?token=${encodeURIComponent(token)}`
      const riderName = String((r as { name?: string }).name ?? 'there')
      const riderPhone = (r as { phone?: string | null }).phone != null ? String((r as { phone?: string | null }).phone).trim() : ''
      // Fire SMS regardless of email outcome (non-blocking)
      if (riderPhone) {
        sendSms(
          riderPhone,
          `Hi ${riderName}, your dornye rider portal invite is ready. Your verification code is: ${otp}. Set your password here: ${resetUrl} (expires in 30 min)`,
        ).catch((e: unknown) => console.warn('SMS rider invite failed:', e))
      }
      // Send email with reset link + OTP code
      const sent = await sendRiderResetEmail(to, riderName, resetUrl, otp)
      if (!sent.ok) {
        // Email failed — return fallback data so admin can share invite manually
        return ok({ data: { emailed: false as const, notice: sent.error, fallback_url: resetUrl, fallback_otp: otp } })
      }
      return ok({ data: { emailed: true as const } })
    }

    if (action === 'admin_save_fleet_bike' || action === 'admin_save_and_assign_fleet_bike') {
      const authHeader = req.headers.get('Authorization') ?? ''
      const gate = await assertDashboardFleetAdmin(sb, authHeader)
      if (!gate.ok) return fail(gate.error)

      const bikeId = typeof body.bikeId === 'string' ? body.bikeId : ''
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const bikeNumber = typeof body.bikeNumber === 'string'
        ? body.bikeNumber.trim().toUpperCase()
        : ''
      const model = typeof body.model === 'string' ? body.model.trim() : ''
      const registrationNumber = typeof body.registrationNumber === 'string'
        ? body.registrationNumber.trim().toUpperCase()
        : ''
      const capacity = Number(body.batteryCapacityKwh)
      const voltage = Number(body.nominalVoltageV)
      const watts = Number(body.motorPowerW)

      if (!bikeNumber || bikeNumber.length > 100) return fail('Valid bike number required')
      if (!model || model.length > 100) return fail('Valid bike model required')
      if (!registrationNumber || registrationNumber.length > 50) {
        return fail('Valid registration number required')
      }
      if (!Number.isFinite(capacity) || capacity <= 0 || capacity > 100) {
        return fail('Battery capacity must be between 0 and 100 kWh')
      }
      if (!Number.isFinite(voltage) || voltage <= 0 || voltage > 1000) {
        return fail('Nominal voltage must be between 0 and 1000 V')
      }
      if (!Number.isInteger(watts) || watts <= 0 || watts > 100000) {
        return fail('Motor power must be between 1 and 100000 W')
      }

      const values = {
        bike_number: bikeNumber,
        model,
        registration_number: registrationNumber,
        battery_capacity_kwh: capacity,
        nominal_voltage_v: voltage,
        motor_power_w: watts,
      }
      const saved = bikeId
        ? await sb.from('fleet_bikes').update(values).eq('id', bikeId).select('*').single()
        : await sb.from('fleet_bikes').insert(values).select('*').single()
      if (saved.error || !saved.data) return fail(formatDbErr(saved.error))

      if (action === 'admin_save_and_assign_fleet_bike') {
        if (!riderId) return fail('riderId required')
        const { data: existingOwner, error: ownerError } = await sb
          .from('rider_bike_assignments')
          .select('id,rider_id')
          .eq('bike_id', saved.data.id)
          .is('returned_at', null)
          .neq('rider_id', riderId)
          .maybeSingle()
        if (ownerError) return fail(formatDbErr(ownerError))
        if (existingOwner) return fail('Bike is already assigned to another rider')

        const now = new Date().toISOString()
        const { error: returnError } = await sb
          .from('rider_bike_assignments')
          .update({ returned_at: now })
          .eq('rider_id', riderId)
          .is('returned_at', null)
          .neq('bike_id', saved.data.id)
        if (returnError) return fail(formatDbErr(returnError))

        const { data: current } = await sb
          .from('rider_bike_assignments')
          .select('id')
          .eq('rider_id', riderId)
          .eq('bike_id', saved.data.id)
          .is('returned_at', null)
          .maybeSingle()
        if (!current) {
          const { error: assignmentError } = await sb
            .from('rider_bike_assignments')
            .insert({
              rider_id: riderId,
              bike_id: saved.data.id,
              assigned_at: now,
              notes: typeof body.notes === 'string' ? body.notes.trim().slice(0, 500) : null,
            })
          if (assignmentError) return fail(formatDbErr(assignmentError))
        }
      }

      return ok({ data: { bike: saved.data, assigned: action === 'admin_save_and_assign_fleet_bike' } })
    }

    if (action === 'update_bike_battery') {
      return fail('Bike specifications are managed by Dornye administrators')
    }

    if (action === 'dashboard_refresh') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      const v = await assertRiderEmail(sb, riderId, email, riderAuthOpts)
      if (!v.ok) return fail(v.error)
      const id = riderId
      // Run the Uber-style auto-dispatch sweep so the nearest online rider is offered each
      // site order (and expired 2-min offers roll to the next nearest) on every poll.
      await runAutoDispatch(sb)
      const { data: riderRow } = await sb.from('riders').select('city, is_online, birthday, phone').eq('id', id).maybeSingle()
      const riderCity = (riderRow as { city?: string | null } | null)?.city ?? null
      const riderOnline = Boolean((riderRow as { is_online?: boolean | null } | null)?.is_online)
      const riderBirthday = (riderRow as { birthday?: string | null } | null)?.birthday ?? null
      const riderPhone = (riderRow as { phone?: string | null } | null)?.phone ?? null
      let myEquipment: unknown[] = []
      try {
        const { data: eq } = await sb.from('rider_equipment').select('id, item_name, size, quantity').eq('rider_id', id).order('created_at', { ascending: false })
        myEquipment = eq ?? []
      } catch { /* table optional */ }
      const [assignedRows, open, reqs] = await Promise.all([
        sb
          .from('orders')
          .select('*, order_items(*)')
          .eq('assigned_rider', id)
          .order('created_at', { ascending: false })
          .limit(200),
        sb
          .from('orders')
          .select('*, order_items(*)')
          .not('business_id', 'is', null)
          .is('assigned_rider', null)
          .eq('status', 'pending')
          .order('created_at', { ascending: false }),
        sb.from('rider_order_requests').select('order_id').eq('rider_id', id).eq('status', 'pending'),
      ])
      const errs = [assignedRows.error, open.error, reqs.error].filter(Boolean)
      if (errs.length) {
        console.error('dashboard_refresh', errs)
        return fail('Query failed')
      }
      const terminal = new Set(['delivered', 'completed', 'refunded'])
      const allAssignedRaw = ((assignedRows.data ?? []) as Record<string, unknown>[])
        .filter((o) => !terminal.has(String(o.status ?? '')))
      const openOrdersRaw = (open.data ?? []) as Record<string, unknown>[]

      // Attach the vendor's name / contact / pickup location so the rider sees full details.
      const bizIds = [...new Set([...allAssignedRaw, ...openOrdersRaw]
        .map((o) => o.business_id).filter(Boolean) as string[])]
      const bizMap: Record<string, { name?: string; branch_name?: string; phone?: string; location_address?: string }> = {}
      if (bizIds.length) {
        const { data: bizs } = await sb.from('businesses').select('id, name, branch_name, phone, location_address').in('id', bizIds)
        for (const b of (bizs ?? []) as Array<Record<string, unknown>>) bizMap[String(b.id)] = b as never
      }
      const attachBiz = (o: Record<string, unknown>) => {
        const b = o.business_id ? bizMap[String(o.business_id)] : undefined
        if (!b) return o
        return { ...o, business_name: b.branch_name || b.name || null, business_phone: b.phone ?? null, business_location: b.location_address ?? null }
      }
      const allAssigned = allAssignedRaw.map(attachBiz)
      const openEnriched = openOrdersRaw.map(attachBiz)
      const pend = { data: allAssigned.filter((o) => o.awaiting_rider_acceptance === true) }
      const act = { data: allAssigned.filter((o) => o.awaiting_rider_acceptance !== true) }
      let pendingPickupOrders: unknown[] = []
      let activePickupOrders: unknown[] = []
      let dornyePickupNotice: string | null = null
      try {
        const pickup = await fetchdornyeBridge<{ pending: unknown[]; active: unknown[] }>(
          'rider_pickup_dashboard',
          { orderzone_rider_id: id },
        )
        pendingPickupOrders = pickup.pending ?? []
        activePickupOrders = pickup.active ?? []
      } catch (e) {
        const msg = e instanceof Error ? e.message : String(e)
        console.warn('dashboard_refresh dornye pickups:', msg)
        if (msg.includes('dornye_BRIDGE')) {
          dornyePickupNotice =
            'dornye pickup & errands are not connected on this server. In Supabase → Edge Functions → rider-portal secrets, set dornye_BRIDGE_URL (your dornye orderzone-bridge URL) and dornye_BRIDGE_SECRET (same value as ORDERZONE_BRIDGE_SECRET on dornye). Redeploy rider-portal, then refresh.'
        } else {
          dornyePickupNotice = `dornye pickups could not load: ${msg}`
        }
      }

      let pendingdornyeFoodOrders: unknown[] = []
      let activedornyeFoodOrders: unknown[] = []
      let dornyeFoodNotice: string | null = null
      try {
        const food = await fetchdornyeBridge<{ pending: unknown[]; active: unknown[] }>(
          'rider_dornye_food_dashboard',
          { orderzone_rider_id: id },
        )
        pendingdornyeFoodOrders = food.pending ?? []
        activedornyeFoodOrders = food.active ?? []
      } catch (e) {
        const msg = e instanceof Error ? e.message : String(e)
        console.warn('dashboard_refresh dornye food:', msg)
        if (msg.includes('dornye_BRIDGE')) {
          dornyeFoodNotice = dornyePickupNotice
            ? null
            : 'dornye bridge not configured (see pickup notice above if shown).'
        } else {
          dornyeFoodNotice = `dornye food orders could not load: ${msg}`
        }
      }

      // Override vendor details on storefront food orders with the OrderZone onboarding
      // business (the source of truth for location/phone/name) — not the dornye-side copy.
      try {
        const foodBizIds = [...new Set(
          [...pendingdornyeFoodOrders, ...activedornyeFoodOrders]
            .map((o) => (o as { business_id?: string }).business_id)
            .filter(Boolean) as string[],
        )]
        if (foodBizIds.length > 0) {
          const { data: fbiz } = await sb.from('businesses').select('id, name, branch_name, phone, location_address').in('id', foodBizIds)
          const fmap: Record<string, { name?: string; branch_name?: string; phone?: string; location_address?: string }> = {}
          for (const b of (fbiz ?? []) as Array<{ id: string; name?: string; branch_name?: string; phone?: string; location_address?: string }>) fmap[b.id] = b
          const enrich = (o: unknown) => {
            const r = o as Record<string, unknown>
            const b = r.business_id ? fmap[String(r.business_id)] : undefined
            if (b) { r.business_name = b.branch_name || b.name || null; r.business_phone = b.phone ?? null; r.business_location = b.location_address ?? null }
            return r
          }
          pendingdornyeFoodOrders = pendingdornyeFoodOrders.map(enrich)
          activedornyeFoodOrders = activedornyeFoodOrders.map(enrich)
        }
      } catch (e) { console.warn('food biz enrich:', e instanceof Error ? e.message : e) }

      // Equipment (helmets, gear) an admin has handed out to this rider.
      let myCatalogItems: unknown[] = []
      try {
        const { data: ci } = await sb
          .from('rider_equipment')
          .select('item_name, size, quantity')
          .eq('rider_id', id)
          .order('created_at', { ascending: false })
        myCatalogItems = ci ?? []
      } catch { /* table optional */ }

      // Equipment requests the rider has submitted (pending/approved/rejected).
      let myEquipmentRequests: unknown[] = []
      try {
        const { data: er } = await sb
          .from('rider_inventory_requests')
          .select('id, item_name, note, status, created_at')
          .eq('rider_id', id)
          .order('created_at', { ascending: false })
          .limit(50)
        myEquipmentRequests = er ?? []
      } catch { /* table optional */ }

      // Fleet bikes are assigned in the admin fleet schema rather than on
      // the rider row. Return the current (not returned) assignment so the
      // Flutter rider app can initialise profile, controls and telemetry.
      let activeBikeAssignment: Record<string, unknown> | null = null
      let assignedBike: Record<string, unknown> | null = null
      try {
        const { data: assignment, error: assignmentError } = await sb
          .from('rider_bike_assignments')
          .select('id,bike_id,assigned_at,notes,fleet_bikes(*)')
          .eq('rider_id', id)
          .is('returned_at', null)
          .order('assigned_at', { ascending: false })
          .limit(1)
          .maybeSingle()
        if (assignmentError) {
          console.error('dashboard_refresh fleet assignment:', assignmentError)
        } else if (assignment) {
          const joinedBike = (assignment as Record<string, unknown>).fleet_bikes
          assignedBike = Array.isArray(joinedBike)
            ? (joinedBike[0] as Record<string, unknown> | undefined) ?? null
            : (joinedBike as Record<string, unknown> | null) ?? null
          activeBikeAssignment = {
            id: assignment.id,
            bikeId: assignment.bike_id,
            assignedAt: assignment.assigned_at,
            notes: assignment.notes,
            bike: assignedBike,
          }
        }
      } catch (e) {
        console.error('dashboard_refresh fleet assignment:', e)
      }

      return ok({
        data: {
          riderCity,
          riderOnline,
          pendingAcceptanceOrders: pend.data ?? [],
          assignedOrders: act.data ?? [],
          openBusinessOrders: openEnriched ?? [],
          requestedOrderIds: (reqs.data ?? []).map((x: { order_id: string }) => x.order_id),
          pendingPickupOrders,
          activePickupOrders,
          dornyePickupNotice,
          pendingdornyeFoodOrders,
          activedornyeFoodOrders,
          dornyeFoodNotice,
          myCatalogItems,
          myEquipment,
          myEquipmentRequests,
          riderBirthday,
          riderPhone,
          assignedBikeId: activeBikeAssignment?.bikeId ?? null,
          assignment: activeBikeAssignment,
          bike: assignedBike,
        },
      })
    }

    if (action === 'accept_pickup_assignment') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      const pickupId = typeof body.pickupId === 'string' ? body.pickupId : ''
      const v = await assertRiderEmail(sb, riderId, email, riderAuthOpts)
      if (!v.ok) return fail(v.error)
      if (!pickupId) return fail('pickupId required')
      try {
        await fetchdornyeBridge('rider_accept_pickup_delivery', {
          id: pickupId,
          orderzone_rider_id: riderId,
        })
      } catch (e) {
        console.error('accept_pickup_assignment', e)
        return fail(e instanceof Error ? e.message : 'dornye accept failed')
      }
      return ok({ data: {} })
    }

    if (action === 'decline_pickup_assignment') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      const pickupId = typeof body.pickupId === 'string' ? body.pickupId : ''
      const v = await assertRiderEmail(sb, riderId, email, riderAuthOpts)
      if (!v.ok) return fail(v.error)
      if (!pickupId) return fail('pickupId required')
      try {
        await fetchdornyeBridge('rider_decline_pickup_delivery', {
          id: pickupId,
          orderzone_rider_id: riderId,
        })
      } catch (e) {
        console.error('decline_pickup_assignment', e)
        return fail(e instanceof Error ? e.message : 'dornye decline failed')
      }
      return ok({ data: {} })
    }

    if (action === 'accept_dornye_food_assignment') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      const foodOrderId = typeof body.foodOrderId === 'string' ? body.foodOrderId : ''
      const v = await assertRiderEmail(sb, riderId, email, riderAuthOpts)
      if (!v.ok) return fail(v.error)
      if (!foodOrderId) return fail('foodOrderId required')
      try {
        await fetchdornyeBridge('rider_accept_dornye_food_order', {
          id: foodOrderId,
          orderzone_rider_id: riderId,
        })
      } catch (e) {
        console.error('accept_dornye_food_assignment', e)
        return fail(e instanceof Error ? e.message : 'dornye accept failed')
      }
      return ok({ data: {} })
    }

    if (action === 'decline_dornye_food_assignment') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      const foodOrderId = typeof body.foodOrderId === 'string' ? body.foodOrderId : ''
      const v = await assertRiderEmail(sb, riderId, email, riderAuthOpts)
      if (!v.ok) return fail(v.error)
      if (!foodOrderId) return fail('foodOrderId required')
      try {
        await fetchdornyeBridge('rider_decline_dornye_food_order', {
          id: foodOrderId,
          orderzone_rider_id: riderId,
        })
      } catch (e) {
        console.error('decline_dornye_food_assignment', e)
        return fail(e instanceof Error ? e.message : 'dornye decline failed')
      }
      return ok({ data: {} })
    }

    if (action === 'dornye_food_payment_update') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      const foodOrderId = typeof body.foodOrderId === 'string' ? body.foodOrderId : ''
      const v = await assertRiderEmail(sb, riderId, email, riderAuthOpts)
      if (!v.ok) return fail(v.error)
      if (!foodOrderId) return fail('foodOrderId required')
      const payment_status = body.payment_status != null ? String(body.payment_status).trim().toLowerCase() : ''
      const payment_method = body.payment_method != null ? String(body.payment_method).trim().toLowerCase() : ''
      const notes_append = body.notes_append != null ? String(body.notes_append).trim() : ''
      if (!payment_status && !payment_method && !notes_append) {
        return fail('payment_status, payment_method, or notes_append required')
      }
      try {
        await fetchdornyeBridge('rider_patch_dornye_food_order', {
          id: foodOrderId,
          orderzone_rider_id: riderId,
          ...(payment_status ? { payment_status } : {}),
          ...(payment_method ? { payment_method } : {}),
          ...(notes_append ? { notes_append } : {}),
        })
      } catch (e) {
        console.error('dornye_food_payment_update', e)
        return fail(e instanceof Error ? e.message : 'dornye update failed')
      }
      return ok({ data: {} })
    }

    if (action === 'dornye_food_delivery_status') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      const foodOrderId = typeof body.foodOrderId === 'string' ? body.foodOrderId : ''
      const foodStatus = typeof body.food_status === 'string' ? body.food_status.trim().toLowerCase() : ''
      const v = await assertRiderEmail(sb, riderId, email, riderAuthOpts)
      if (!v.ok) return fail(v.error)
      if (!foodOrderId) return fail('foodOrderId required')
      if (foodStatus !== 'out_for_delivery' && foodStatus !== 'delivered') {
        return fail('food_status must be out_for_delivery or delivered')
      }
      try {
        await fetchdornyeBridge('rider_patch_dornye_food_order', {
          id: foodOrderId,
          orderzone_rider_id: riderId,
          status: foodStatus,
        })
      } catch (e) {
        console.error('dornye_food_delivery_status', e)
        return fail(e instanceof Error ? e.message : 'dornye update failed')
      }
      return ok({ data: {} })
    }

    if (action === 'dornye_pickup_ride_update') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      const pickupId = typeof body.pickupId === 'string' ? body.pickupId : ''
      const v = await assertRiderEmail(sb, riderId, email, riderAuthOpts)
      if (!v.ok) return fail(v.error)
      if (!pickupId) return fail('pickupId required')
      const payment_status = body.payment_status != null ? String(body.payment_status).trim().toLowerCase() : ''
      const payment_method = body.payment_method != null ? String(body.payment_method).trim().toLowerCase() : ''
      const notes_append = body.notes_append != null ? String(body.notes_append).trim() : ''
      const pickup_status = body.pickup_status != null ? String(body.pickup_status).trim().toLowerCase() : ''
      const errand_purchased_items = Array.isArray(body.errand_purchased_items) ? body.errand_purchased_items : null
      // Rider-confirmed final delivery fee (used when the customer didn't set a pickup pin).
      const deliveryFeeNum = body.delivery_fee != null ? Number(body.delivery_fee) : NaN
      const delivery_fee = Number.isFinite(deliveryFeeNum) && deliveryFeeNum >= 0 ? deliveryFeeNum : null
      if (!payment_status && !payment_method && !notes_append && !pickup_status && !errand_purchased_items && delivery_fee == null) {
        return fail('payment_status, payment_method, notes_append, pickup_status, errand_purchased_items, or delivery_fee required')
      }
      if (pickup_status && pickup_status !== 'out_for_delivery' && pickup_status !== 'delivered' && pickup_status !== 'cancelled') {
        return fail('pickup_status must be out_for_delivery, delivered, or cancelled')
      }
      try {
        await fetchdornyeBridge('rider_patch_pickup_delivery_ride', {
          id: pickupId,
          orderzone_rider_id: riderId,
          ...(payment_status ? { payment_status } : {}),
          ...(payment_method ? { payment_method } : {}),
          ...(notes_append ? { notes_append } : {}),
          ...(pickup_status ? { status: pickup_status } : {}),
          ...(errand_purchased_items ? { errand_purchased_items } : {}),
          ...(delivery_fee != null ? { delivery_fee } : {}),
        })
      } catch (e) {
        console.error('dornye_pickup_ride_update', e)
        return fail(e instanceof Error ? e.message : 'dornye update failed')
      }
      return ok({ data: {} })
    }

    if (action === 'dornye_pickup_share_location') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      const pickupId = typeof body.pickupId === 'string' ? body.pickupId : ''
      const lat = typeof body.lat === 'number' ? body.lat : Number(body.lat)
      const lng = typeof body.lng === 'number' ? body.lng : Number(body.lng)
      const v = await assertRiderEmail(sb, riderId, email, riderAuthOpts)
      if (!v.ok) return fail(v.error)
      if (!pickupId) return fail('pickupId required')
      if (Number.isNaN(lat) || Number.isNaN(lng)) return fail('Invalid coordinates')
      try {
        await fetchdornyeBridge('rider_patch_pickup_delivery_ride', {
          id: pickupId,
          orderzone_rider_id: riderId,
          rider_last_lat: lat,
          rider_last_lng: lng,
        })
      } catch (e) {
        console.error('dornye_pickup_share_location', e)
        return fail(e instanceof Error ? e.message : 'dornye update failed')
      }
      return ok({ data: {} })
    }

    if (action === 'complete_pickup_assignment') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      const pickupId = typeof body.pickupId === 'string' ? body.pickupId : ''
      const v = await assertRiderEmail(sb, riderId, email, riderAuthOpts)
      if (!v.ok) return fail(v.error)
      if (!pickupId) return fail('pickupId required')
      try {
        await fetchdornyeBridge('rider_complete_pickup_delivery', {
          id: pickupId,
          orderzone_rider_id: riderId,
        })
      } catch (e) {
        console.error('complete_pickup_assignment', e)
        return fail(e instanceof Error ? e.message : 'dornye update failed')
      }
      return ok({ data: {} })
    }

    if (action === 'pickup_messages_list') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      const pickupId = typeof body.pickupId === 'string' ? body.pickupId : ''
      const v = await assertRiderEmail(sb, riderId, email, riderAuthOpts)
      if (!v.ok) return fail(v.error)
      if (!pickupId) return fail('pickupId required')
      try {
        const rows = await fetchdornyeBridge<unknown[]>(
          'rider_list_pickup_messages',
          { order_id: pickupId, orderzone_rider_id: riderId },
        )
        return ok({ data: { messages: Array.isArray(rows) ? rows : [] } })
      } catch (e) {
        console.error('pickup_messages_list', e)
        return fail(e instanceof Error ? e.message : 'Could not load messages')
      }
    }

    if (action === 'pickup_message_send') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      const pickupId = typeof body.pickupId === 'string' ? body.pickupId : ''
      const msgBody = typeof body.body === 'string' ? body.body.trim() : ''
      const v = await assertRiderEmail(sb, riderId, email, riderAuthOpts)
      if (!v.ok) return fail(v.error)
      if (!pickupId || !msgBody) return fail('pickupId and body required')
      try {
        await fetchdornyeBridge('rider_append_pickup_message', {
          order_id: pickupId,
          orderzone_rider_id: riderId,
          body: msgBody,
        })
        return ok({ data: {} })
      } catch (e) {
        console.error('pickup_message_send', e)
        return fail(e instanceof Error ? e.message : 'Could not send message')
      }
    }

    if (action === 'delivery_history') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      const v = await assertRiderEmail(sb, riderId, email, riderAuthOpts)
      if (!v.ok) return fail(v.error)
      const from = typeof body.from === 'string' && body.from.trim() ? body.from.trim() : null
      const to = typeof body.to === 'string' && body.to.trim() ? body.to.trim() : null
      const locationQ = typeof body.locationQ === 'string' ? body.locationQ.trim().toLowerCase() : ''

      let completedQ = sb
        .from('orders')
        .select(
          'id, customer_name, status, total_price, delivery_fee, created_at, updated_at, delivery_address, pickup_location, notes',
        )
        .eq('assigned_rider', riderId)
        .in('status', ['completed', 'delivered'])
        .order('created_at', { ascending: false })
        .limit(250)
      if (from) completedQ = completedQ.gte('created_at', from)
      if (to) completedQ = completedQ.lte('created_at', to)
      const { data: completedRows, error: ce } = await completedQ
      if (ce) {
        console.error('delivery_history completed', ce)
        return fail('Query failed')
      }
      let completed = completedRows ?? []
      if (locationQ) {
        completed = completed.filter((o: Record<string, unknown>) => {
          const hay = [o.delivery_address, o.pickup_location, o.notes, o.customer_name]
            .map((x) => String(x ?? '').toLowerCase())
            .join(' ')
          return hay.includes(locationQ)
        })
      }

      let rejQ = sb
        .from('rider_order_requests')
        .select(
          'order_id, resolved_at, orders ( id, customer_name, status, total_price, delivery_fee, created_at, delivery_address, pickup_location )',
        )
        .eq('rider_id', riderId)
        .eq('status', 'rejected')
        .order('resolved_at', { ascending: false })
        .limit(150)
      if (from) rejQ = rejQ.gte('resolved_at', from)
      if (to) rejQ = rejQ.lte('resolved_at', to)
      const { data: rejRows, error: re } = await rejQ
      if (re) {
        console.error('delivery_history rejected', re)
        return fail('Query failed')
      }
      let rejected: unknown[] = rejRows ?? []
      if (locationQ) {
        rejected = (rejected as Record<string, unknown>[]).filter((row) => {
          const ord = row.orders as Record<string, unknown> | null
          const hay = [
            ord?.delivery_address,
            ord?.pickup_location,
            ord?.customer_name,
          ]
            .map((x) => String(x ?? '').toLowerCase())
            .join(' ')
          return hay.includes(locationQ)
        })
      }

      let ongoingQ = sb
        .from('orders')
        .select(
          'id, customer_name, status, total_price, delivery_fee, created_at, delivery_address, pickup_location, notes',
        )
        .eq('assigned_rider', riderId)
        .in('status', ['packaged', 'in_transit'])
        .order('created_at', { ascending: false })
        .limit(120)
      if (from) ongoingQ = ongoingQ.gte('created_at', from)
      if (to) ongoingQ = ongoingQ.lte('created_at', to)
      const { data: ongoingRows, error: oe } = await ongoingQ
      if (oe) {
        console.error('delivery_history ongoing', oe)
        return fail('Query failed')
      }
      let ongoing = ongoingRows ?? []
      if (locationQ) {
        ongoing = ongoing.filter((o: Record<string, unknown>) => {
          const hay = [o.delivery_address, o.pickup_location, o.notes, o.customer_name]
            .map((x) => String(x ?? '').toLowerCase())
            .join(' ')
          return hay.includes(locationQ)
        })
      }

      try {
        const [dornyeFood, dornyePickup] = await Promise.all([
          fetchdornyeBridge<Record<string, unknown>[]>('list_orders', { limit: 1200 }),
          fetchdornyeBridge<Record<string, unknown>[]>('list_pickup_orders', { limit: 1200 }),
        ])
        const riderFood = (dornyeFood ?? []).filter(
          (o) => String(o.orderzone_rider_id ?? '').trim() === riderId,
        )
        const riderPickup = (dornyePickup ?? []).filter(
          (o) => String(o.orderzone_rider_id ?? '').trim() === riderId,
        )
        for (const o of riderFood) {
          const status = String(o.status ?? '').toLowerCase()
          const row = {
            ...o,
            source: 'dornye-food',
            amount: Number(o.total ?? 0),
            customer_name: (o.user as Record<string, unknown> | null)?.name ?? (o.user as Record<string, unknown> | null)?.email ?? 'Customer',
            location_text: ((o.address as Record<string, unknown> | null)?.label ?? (o.address as Record<string, unknown> | null)?.zone ?? '—') as string,
          }
          if (status === 'delivered' || status === 'completed') completed.push(row)
          else if (status !== 'cancelled') ongoing.push(row)
        }
        for (const p of riderPickup) {
          const status = String(p.status ?? '').toLowerCase()
          const row = {
            ...p,
            source: 'dornye-pickup',
            amount: Number(p.delivery_fee ?? 0),
            customer_name: (p.user as Record<string, unknown> | null)?.name ?? (p.user as Record<string, unknown> | null)?.email ?? 'Customer',
            location_text: `${(p.pickup_address as Record<string, unknown> | null)?.label ?? '—'} -> ${(p.delivery_address as Record<string, unknown> | null)?.label ?? '—'}`,
          }
          if (status === 'cancelled') rejected.push(row)
          else if (status === 'delivered' || status === 'completed') completed.push(row)
          else ongoing.push(row)
        }
      } catch (bridgeError) {
        console.error('delivery_history dornye merge', bridgeError)
      }

      if (locationQ) {
        const byLocation = (row: Record<string, unknown>) =>
          [row.delivery_address, row.pickup_location, row.location_text, row.customer_name, row.notes]
            .map((x) => String(x ?? '').toLowerCase())
            .join(' ')
            .includes(locationQ)
        completed = (completed as Record<string, unknown>[]).filter(byLocation)
        ongoing = (ongoing as Record<string, unknown>[]).filter(byLocation)
        rejected = (rejected as Record<string, unknown>[]).filter(byLocation)
      }

      return ok({
        data: {
          completed,
          rejected,
          ongoing,
        },
      })
    }

    if (action === 'update_location') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      const lat = typeof body.lat === 'number' ? body.lat : Number(body.lat)
      const lng = typeof body.lng === 'number' ? body.lng : Number(body.lng)
      const v = await assertRiderEmail(sb, riderId, email, riderAuthOpts)
      if (!v.ok) return fail(v.error)
      if (Number.isNaN(lat) || Number.isNaN(lng)) return fail('Invalid coordinates')
      const { error } = await sb
        .from('riders')
        .update({ current_lat: lat, current_lng: lng, updated_at: new Date().toISOString() })
        .eq('id', riderId)
      if (error) {
        console.error('update_location', error)
        return fail('Update failed')
      }
      return ok({ data: {} })
    }

    if (action === 'tracker_snapshot') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      if (!riderId) return fail('riderId required')
      const v = await assertRiderEmail(sb, riderId, email, riderAuthOpts)
      if (!v.ok) return fail(v.error)
      const { data: orders, error } = await sb
        .from('orders')
        .select('*, order_items(*)')
        .eq('assigned_rider', riderId)
        .eq('status', 'in_transit')
        .order('created_at', { ascending: false })
      if (error) {
        console.error('tracker_snapshot', error)
        return fail('Query failed')
      }
      return ok({
        data: { riderName: v.rider.name, orders: orders ?? [] },
      })
    }

    if (action === 'tracker_update_location') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      const lat = typeof body.lat === 'number' ? body.lat : Number(body.lat)
      const lng = typeof body.lng === 'number' ? body.lng : Number(body.lng)
      const v = await assertRiderEmail(sb, riderId, email, riderAuthOpts)
      if (!v.ok) return fail(v.error)
      if (Number.isNaN(lat) || Number.isNaN(lng)) return fail('Invalid coordinates')
      const { error } = await sb
        .from('riders')
        .update({ current_lat: lat, current_lng: lng, updated_at: new Date().toISOString() })
        .eq('id', riderId)
      if (error) {
        console.error('tracker_update_location', error)
        return fail('Update failed')
      }
      return ok({ data: {} })
    }

    if (action === 'accept_assignment') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      const orderId = typeof body.orderId === 'string' ? body.orderId : ''
      const v = await assertRiderOwnsOrder(sb, riderId, email, orderId, riderAuthOpts)
      if (!v.ok) return fail(v.error)
      const { error } = await sb
        .from('orders')
        .update({
          awaiting_rider_acceptance: false,
          rider_accepted_at: new Date().toISOString(),
          status: 'in_transit',
          dispatch_expires_at: null,
          updated_at: new Date().toISOString(),
        })
        .eq('id', orderId)
      if (error) {
        console.error('accept_assignment', error)
        return fail('Update failed')
      }
      await notifyVendor(sb, orderId, (ref) => `Dornye: your rider accepted order ${ref || '#' + orderId.slice(0, 8)}. It is now in transit.`)
      return ok({ data: {} })
    }

    if (action === 'decline_assignment') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      const orderId = typeof body.orderId === 'string' ? body.orderId : ''
      const v = await assertRiderOwnsOrder(sb, riderId, email, orderId, riderAuthOpts)
      if (!v.ok) return fail(v.error)
      // For auto-dispatch orders, record this rider as declined so the next sweep rolls the offer
      // to the next nearest rider (and keep it 'pending' so it gets re-offered).
      const { data: cur } = await sb.from('orders').select('auto_dispatch, dispatch_declined').eq('id', orderId).maybeSingle()
      const isAuto = Boolean((cur as { auto_dispatch?: boolean } | null)?.auto_dispatch)
      const declined: string[] = Array.isArray((cur as { dispatch_declined?: string[] } | null)?.dispatch_declined) ? (cur as { dispatch_declined: string[] }).dispatch_declined : []
      if (isAuto && riderId && !declined.includes(riderId)) declined.push(riderId)
      const { error } = await sb
        .from('orders')
        .update({
          assigned_rider: null,
          assigned_rider_name: null,
          assigned_rider_phone: null,
          awaiting_rider_acceptance: false,
          rider_accepted_at: null,
          status: isAuto ? 'pending' : 'packaged',
          dispatch_expires_at: null,
          dispatch_declined: declined,
          updated_at: new Date().toISOString(),
        })
        .eq('id', orderId)
      if (error) {
        console.error('decline_assignment', error)
        return fail('Update failed')
      }
      if (isAuto) await runAutoDispatch(sb) // immediately roll to the next nearest rider
      else await notifyVendor(sb, orderId, (ref) => `Dornye: your rider declined order ${ref || '#' + orderId.slice(0, 8)}. Please assign another rider.`)
      return ok({ data: {} })
    }

    if (action === 'request_job') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      const orderId = typeof body.orderId === 'string' ? body.orderId : ''
      const v = await assertRiderEmail(sb, riderId, email, riderAuthOpts)
      if (!v.ok) return fail(v.error)
      const { data: row, error: e1 } = await sb.from('orders').select('business_id').eq('id', orderId).maybeSingle()
      if (e1 || !row?.business_id) return fail('Invalid order')
      const { error: e2 } = await sb.from('rider_order_requests').upsert(
        {
          order_id: orderId,
          rider_id: riderId,
          business_id: row.business_id,
          status: 'pending',
          resolved_at: null,
        },
        { onConflict: 'order_id,rider_id' },
      )
      if (e2) {
        console.error('request_job', e2)
        return fail('Upsert failed')
      }
      return ok({ data: {} })
    }

    if (action === 'order_set_status') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      const orderId = typeof body.orderId === 'string' ? body.orderId : ''
      const status = typeof body.status === 'string' ? body.status : ''
      const v = await assertRiderOwnsOrder(sb, riderId, email, orderId, riderAuthOpts)
      if (!v.ok) return fail(v.error)
      if (status !== 'in_transit' && status !== 'completed') return fail('Invalid status')
      const { error } = await sb
        .from('orders')
        .update({ status, updated_at: new Date().toISOString() })
        .eq('id', orderId)
      if (error) {
        console.error('order_set_status', error)
        return fail('Update failed')
      }

      // Fire-and-forget SMS to customer when rider picks up the order
      if (status === 'in_transit') {
        ;(async () => {
          try {
            const { data: ord } = await sb
              .from('orders')
              .select('customer_phone, customer_name')
              .eq('id', orderId)
              .maybeSingle()
            const phone = (ord as { customer_phone?: string | null } | null)?.customer_phone ?? ''
            const name = (ord as { customer_name?: string | null } | null)?.customer_name ?? 'Customer'
            if (phone) {
              await sendSms(phone, `Hi ${name}, your order is on its way! Your rider is heading to you now. Thank you for ordering with dornye.`)
            }
          } catch (e) {
            console.warn('in_transit SMS failed:', e)
          }
        })()
      }

      return ok({ data: {} })
    }

    if (action === 'propose_delivery_fee') {
      // Rider proposes/edits the delivery fee (negotiation). Marks it not-yet-agreed
      // so the admin can agree or counter. Shows on the admin portal.
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      const orderId = typeof body.orderId === 'string' ? body.orderId : ''
      const fee = typeof body.delivery_fee === 'number' ? body.delivery_fee : Number(body.delivery_fee)
      const v = await assertRiderOwnsOrder(sb, riderId, email, orderId, riderAuthOpts)
      if (!v.ok) return fail(v.error)
      if (!Number.isFinite(fee) || fee < 0) return fail('Invalid fee')
      const { error } = await sb
        .from('orders')
        .update({ delivery_fee: fee, delivery_fee_agreed: false, updated_at: new Date().toISOString() })
        .eq('id', orderId)
      if (error) {
        console.error('propose_delivery_fee', error)
        return fail('Update failed')
      }
      return ok({ data: {} })
    }

    if (action === 'record_payment') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      const orderId = typeof body.orderId === 'string' ? body.orderId : ''
      const v = await assertRiderOwnsOrder(sb, riderId, email, orderId, riderAuthOpts)
      if (!v.ok) return fail(v.error)
      const payment_splits = body.payment_splits
      if (!Array.isArray(payment_splits)) return fail('payment_splits required')
      const noteParts = payment_splits.map((s: Record<string, unknown>) => {
        const method = String(s.method ?? '')
        const network = s.network ? String(s.network).toUpperCase() : ''
        const amount = Number(s.amount)
        const note = s.note ? String(s.note) : ''
        return `${method}${network ? ` (${network})` : ''}: ₵${Number.isNaN(amount) ? '?' : amount.toFixed(2)}${note ? ` - ${note}` : ''}`
      })
      const first = payment_splits[0] as Record<string, unknown> | undefined
      const { error } = await sb
        .from('orders')
        .update({
          payment_status: 'paid',
          payment_splits,
          payment_method: payment_splits.length === 1 && first?.method ? String(first.method) : null,
          rider_payment_note: noteParts.join(', '),
          updated_at: new Date().toISOString(),
        })
        .eq('id', orderId)
      if (error) {
        console.error('record_payment', error)
        return fail('Update failed')
      }

      // For BUSINESS orders, record what the rider collected into the settlement page
      // so the business can confirm remittance. Cash vs MoMo split from payment_splits.
      try {
        const { data: ord } = await sb
          .from('orders')
          .select('business_id, business_rider_id')
          .eq('id', orderId)
          .maybeSingle()
        const businessId = (ord as { business_id?: string | null } | null)?.business_id ?? null
        if (businessId) {
          const amtOf = (re: RegExp) => payment_splits
            .filter((s: Record<string, unknown>) => re.test(String(s.method ?? '').toLowerCase()))
            .reduce((sum: number, s: Record<string, unknown>) => sum + (Number(s.amount) || 0), 0)
          const cashAmt = amtOf(/cash/)
          const momoAmt = amtOf(/momo|mobile/)
          const row = {
            business_id: businessId,
            rider_id: riderId,
            business_rider_id: (ord as { business_rider_id?: string | null } | null)?.business_rider_id ?? null,
            order_id: orderId,
            status: 'awaiting_business',
            total_cash_customer_paid: cashAmt,
            rider_remitted_cash: cashAmt,
            rider_remitted_momo: momoAmt,
            notes: noteParts.join(', '),
            updated_at: new Date().toISOString(),
          }
          const { data: existing } = await sb
            .from('business_trip_settlements')
            .select('id, business_confirmed_at')
            .eq('order_id', orderId)
            .maybeSingle()
          const ex = existing as { id?: string; business_confirmed_at?: string | null } | null
          if (ex?.id) {
            // Don't disturb an already-confirmed settlement.
            if (!ex.business_confirmed_at) await sb.from('business_trip_settlements').update(row).eq('id', ex.id)
          } else {
            await sb.from('business_trip_settlements').insert(row)
          }
        }
      } catch (e) {
        console.warn('record_payment settlement upsert failed:', e)
      }

      return ok({ data: {} })
    }

    if (action === 'tracker_order_set_status') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      const orderId = typeof body.orderId === 'string' ? body.orderId : ''
      const status = typeof body.status === 'string' ? body.status : ''
      const v = await assertRiderOwnsOrder(sb, riderId, email, orderId, riderAuthOpts)
      if (!v.ok) return fail(v.error)
      if (status !== 'completed') return fail('Invalid status')
      const { error } = await sb
        .from('orders')
        .update({ status: 'completed', updated_at: new Date().toISOString() })
        .eq('id', orderId)
      if (error) {
        console.error('tracker_order_set_status', error)
        return fail('Update failed')
      }
      return ok({ data: {} })
    }

    if (action === 'tracker_record_payment') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      const orderId = typeof body.orderId === 'string' ? body.orderId : ''
      const payment_splits = body.payment_splits
      const v = await assertRiderOwnsOrder(sb, riderId, email, orderId, riderAuthOpts)
      if (!v.ok) return fail(v.error)
      if (!Array.isArray(payment_splits)) return fail('payment_splits required')
      const noteParts = payment_splits.map((s: Record<string, unknown>) => {
        const method = String(s.method ?? '')
        const network = s.network ? String(s.network).toUpperCase() : ''
        const amount = Number(s.amount)
        const note = s.note ? String(s.note) : ''
        return `${method}${network ? ` (${network})` : ''}: ₵${Number.isNaN(amount) ? '?' : amount.toFixed(2)}${note ? ` - ${note}` : ''}`
      })
      const first = payment_splits[0] as Record<string, unknown> | undefined
      const { error } = await sb
        .from('orders')
        .update({
          payment_status: 'paid',
          payment_splits,
          payment_method: payment_splits.length === 1 && first?.method ? String(first.method) : null,
          rider_payment_note: noteParts.join(', '),
          updated_at: new Date().toISOString(),
        })
        .eq('id', orderId)
      if (error) {
        console.error('tracker_record_payment', error)
        return fail('Update failed')
      }
      return ok({ data: {} })
    }

    if (action === 'list_businesses') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      const v = await assertRiderEmail(sb, riderId, email, riderAuthOpts)
      if (!v.ok) return fail(v.error)
      const { data, error } = await sb
        .from('businesses')
        .select('id,name,branch_name,city')
        .order('name', { ascending: true })
      if (error) {
        console.error('list_businesses', error)
        return fail('Query failed')
      }
      return ok({ data: { businesses: data ?? [] } })
    }

    if (action === 'rider_place_business_order') {
      const riderId = typeof body.riderId === 'string' ? body.riderId : ''
      const email = typeof body.email === 'string' ? body.email : ''
      const businessId = typeof body.businessId === 'string' ? body.businessId : ''
      const description =
        typeof body.description === 'string' ? body.description.trim() : ''
      const deliveryAddress =
        typeof body.deliveryAddress === 'string' ? body.deliveryAddress.trim() : ''
      const totalRaw = body.totalPrice
      const totalPrice =
        typeof totalRaw === 'number' ? totalRaw : totalRaw != null ? Number(totalRaw) : 0

      if (!businessId || !description) return fail('businessId and description required')

      const v = await assertRiderEmail(sb, riderId, email, riderAuthOpts)
      if (!v.ok) return fail(v.error)

      const { data: biz, error: be } = await sb
        .from('businesses')
        .select('id')
        .eq('id', businessId)
        .maybeSingle()
      if (be || !biz?.id) return fail('Business not found')

      const notes = deliveryAddress
        ? `${description}\nDelivery: ${deliveryAddress}`
        : description
      const tp = Number.isFinite(totalPrice) && totalPrice >= 0 ? totalPrice : 0
      const riderPhone =
        v.rider.phone != null && String(v.rider.phone).trim() ? String(v.rider.phone).trim() : ''
      const fullNotes = `[Rider app → business] ${v.rider.name}${v.rider.email ? ` <${v.rider.email}>` : ''}\n${notes}`

      const { data: ord, error: oe } = await sb
        .from('orders')
        .insert({
          customer_name: v.rider.name,
          customer_phone: riderPhone,
          // `rider_errand` requires add_business_workflows migration; `manual` works on every DB.
          source: 'rider_errand',
          status: 'pending',
          total_price: tp,
          delivery_fee: 0,
          delivery_type: 'errand',
          delivery_address: deliveryAddress || null,
          notes: fullNotes,
          business_id: businessId,
          created_by_rider_id: riderId,
          assigned_rider: null,
          awaiting_rider_acceptance: false,
          updated_at: new Date().toISOString(),
        })
        .select('id')
        .single()

      if (oe) {
        console.error('rider_place_business_order', oe)
        const msg = formatDbErr(oe)
        return fail(msg || 'Could not create order')
      }

      const lineName = description.length > 200 ? `${description.slice(0, 197)}...` : description
      const { error: ie } = await sb.from('order_items').insert({
        order_id: ord.id,
        item_name: lineName || 'Rider request',
        size: '—',
        quantity: 1,
        price: tp,
      })
      if (ie) {
        console.error('rider_place_business_order item', ie)
        return fail(formatDbErr(ie) || 'Order created but line item failed')
      }
      return ok({ data: { orderId: ord.id as string } })
    }

    return fail('Unknown action')
  } catch (e) {
    console.error(e)
    return json(500, { ok: false, error: 'Internal error' })
  }
})
