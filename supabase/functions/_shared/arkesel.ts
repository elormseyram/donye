/**
 * Arkesel SMS helper — shared across Edge Functions.
 *
 * Required env vars (set in Supabase Dashboard → Edge Functions):
 *   ARKESEL_API_KEY    — your Arkesel v2 API key
 *   ARKESEL_SENDER_ID  — registered sender ID (max 11 chars)
 */

const ARKESEL_SEND_URL = 'https://sms.arkesel.com/api/v2/sms/send';

/**
 * Normalise a Ghana phone number to international format (233XXXXXXXXX).
 * Accepts: 0241234567, +233241234567, 233241234567, 024-123-4567, etc.
 * Returns null if the number cannot be normalised.
 */
export function normaliseGhanaPhone(raw: string): string | null {
  const digits = raw.replace(/[\s\-\+\(\)]/g, '');
  if (digits.length === 10 && digits.startsWith('0')) {
    return '233' + digits.slice(1);
  }
  if (digits.length === 12 && digits.startsWith('233')) {
    return digits;
  }
  if (digits.length === 9 && /^[2-9]/.test(digits)) {
    return '233' + digits;
  }
  return null;
}

export interface SmsSendResult {
  ok: boolean;
  error?: string;
}

/**
 * Send an SMS via Arkesel API v2.
 * Returns `{ ok: true }` on success, or `{ ok: false, error }` on failure.
 * Never throws — always returns a result object.
 */
export async function sendSms(to: string, message: string): Promise<SmsSendResult> {
  const apiKey = Deno.env.get('ARKESEL_API_KEY')?.trim() ?? '';
  const senderId = Deno.env.get('ARKESEL_SENDER_ID')?.trim() ?? '';

  if (!apiKey) {
    return { ok: false, error: 'ARKESEL_API_KEY not configured' };
  }
  if (!senderId) {
    return { ok: false, error: 'ARKESEL_SENDER_ID not configured' };
  }

  const phone = normaliseGhanaPhone(to);
  if (!phone) {
    return { ok: false, error: `Invalid phone number: ${to}` };
  }

  try {
    const res = await fetch(ARKESEL_SEND_URL, {
      method: 'POST',
      headers: {
        'api-key': apiKey,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        sender: senderId,
        message,
        recipients: [phone],
      }),
    });

    if (!res.ok) {
      const txt = await res.text();
      return { ok: false, error: `Arkesel HTTP ${res.status}: ${txt.slice(0, 300)}` };
    }

    return { ok: true };
  } catch (e) {
    const msg = e instanceof Error ? e.message : String(e);
    return { ok: false, error: `Arkesel request failed: ${msg}` };
  }
}
