// src/services/bikeControl.service.js
// Mirrors Flutter's BikeControlDataSource.
// Now publishes commands to the bike via MQTT in addition to logging them.

import { asyncHandler } from '../middleware/errorHandler.js';
import { publishCommand } from './mqtt.service.js';

const VALID_COMMAND_TYPES = [
  'lock', 'unlock', 'disable', 'enable', 'honk', 'lights_on', 'lights_off',
];
const VALID_STATUSES = ['pending', 'sent', 'acknowledged', 'failed'];

/**
 * POST /api/v1/bike-control/command
 * Body: { bikeId, type, payload? }
 * 1. Logs the command to Supabase (audit trail)
 * 2. Publishes the command to the bike via MQTT
 */
export const sendCommand = asyncHandler(async (req, res) => {
  const { bikeId, type, payload } = req.body;

  if (!bikeId) {
    return res.status(422).json({ success: false, error: 'bikeId is required' });
  }
  if (!VALID_COMMAND_TYPES.includes(type)) {
    return res.status(422).json({
      success: false,
      error: `type must be one of: ${VALID_COMMAND_TYPES.join(', ')}`,
    });
  }

  const issuedAt = new Date().toISOString();

  // Log command to database
  const { data, error } = await req.supabase
    .from('bike_commands')
    .insert({
      bike_id:   bikeId,
      type,
      payload:   payload ?? null,
      issued_at: issuedAt,
      status:    'sent',
      rider_id:  req.user.id,
    })
    .select()
    .single();

  if (error) throw error;

  // Publish to bike via MQTT
  const published = publishCommand(bikeId, { type, payload: payload ?? null });

  return res.status(201).json({
    success: true,
    data,
    mqttDelivered: published,
  });
});

/**
 * GET /api/v1/bike-control/commands
 * Query: ?bikeId=<id>&limit=20
 */
export const getCommandHistory = asyncHandler(async (req, res) => {
  const { bikeId } = req.query;
  const limit = Math.min(parseInt(req.query.limit, 10) || 20, 100);

  if (!bikeId) {
    return res.status(422).json({ success: false, error: 'bikeId query param is required' });
  }

  const { data, error } = await req.supabase
    .from('bike_commands')
    .select('*')
    .eq('bike_id', bikeId)
    .order('issued_at', { ascending: false })
    .limit(limit);

  if (error) throw error;

  return res.json({ success: true, data });
});

/**
 * PATCH /api/v1/bike-control/commands/:id/status
 * Body: { status: 'acknowledged' | 'failed' }
 * Called by the IoT device to confirm command receipt.
 */
export const updateCommandStatus = asyncHandler(async (req, res) => {
  const { id } = req.params;
  const { status } = req.body;

  if (!VALID_STATUSES.includes(status)) {
    return res.status(422).json({
      success: false,
      error: `status must be one of: ${VALID_STATUSES.join(', ')}`,
    });
  }

  const { data, error } = await req.supabase
    .from('bike_commands')
    .update({ status })
    .eq('id', id)
    .select()
    .single();

  if (error) {
    if (error.code === 'PGRST116') {
      return res.status(404).json({ success: false, error: 'Command not found' });
    }
    throw error;
  }

  return res.json({ success: true, data });
});
