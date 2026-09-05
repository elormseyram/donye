// src/server.js
import 'dotenv/config';
import app from './app.js';
import logger from './config/logger.js';
import { connectMQTT, disconnectMQTT } from './services/mqtt.service.js';

const PORT = process.env.PORT || 3000;

const server = app.listen(PORT, () => {
  logger.info(`🚀 Backend running on port ${PORT} [${process.env.NODE_ENV ?? 'development'}]`);

  // Connect to MQTT broker after server starts
  connectMQTT();
});

const shutdown = (signal) => {
  logger.info(`${signal} received — shutting down gracefully`);

  // Disconnect MQTT cleanly
  disconnectMQTT();

  server.close(() => {
    logger.info('HTTP server closed');
    process.exit(0);
  });

  setTimeout(() => { logger.error('Forced shutdown'); process.exit(1); }, 10_000);
};

process.on('SIGTERM', () => shutdown('SIGTERM'));
process.on('SIGINT',  () => shutdown('SIGINT'));
process.on('unhandledRejection', (reason) => logger.error('Unhandled rejection:', reason));
process.on('uncaughtException',  (err)    => { logger.error('Uncaught exception:', err); process.exit(1); });

export default server;
