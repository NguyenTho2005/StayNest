import { app } from './app.js';
import { config } from './config.js';
import { closeDatabase, initializeEmbeddedDemo } from './db.js';

await initializeEmbeddedDemo();

const server = app.listen(config.port, config.host, () => {
  process.stdout.write(`StayNest API listening on http://${config.host}:${config.port}\n`);
});

let isShuttingDown = false;
async function shutdown(signal) {
  if (isShuttingDown) return;
  isShuttingDown = true;
  process.stdout.write(`Received ${signal}, initiating graceful shutdown...\n`);

  const forceExit = setTimeout(() => {
    process.stderr.write('Forced shutdown: deadline exceeded, exiting immediately.\n');
    process.exit(1);
  }, 10000);
  forceExit.unref();

  try {
    await new Promise((resolve) => server.close(resolve));
    await closeDatabase();
    process.stdout.write('Graceful shutdown completed.\n');
    process.exit(0);
  } catch (err) {
    process.stderr.write(`Error during shutdown: ${err.message}\n`);
    process.exit(1);
  }
}

process.once('SIGINT', () => shutdown('SIGINT'));
process.once('SIGTERM', () => shutdown('SIGTERM'));
