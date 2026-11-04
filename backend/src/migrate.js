import { readFile, readdir } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';
import { resolve } from 'node:path';
import { pool, requireDatabase } from './db.js';

const directory = fileURLToPath(new URL('../db/migrations/', import.meta.url));

export async function runMigrations(customDb = null) {
  const database = customDb ?? (await requireDatabase());
  const isPool = typeof database.connect === 'function';
  const client = isPool ? await database.connect() : database;
  let lockAcquired = false;

  try {
    try {
      await client.query('SELECT pg_advisory_lock(748391)');
      lockAcquired = true;
    } catch (err) {
      throw new Error(`Failed to acquire migration advisory lock: ${err.message}`);
    }

    await client.query(`CREATE TABLE IF NOT EXISTS schema_migrations (
      filename text PRIMARY KEY,
      applied_at timestamptz NOT NULL DEFAULT now()
    )`);

    const files = (await readdir(directory))
      .filter((name) => /^\d+_.*\.sql$/.test(name))
      .sort();

    const applied = [];
    for (const file of files) {
      const existing = await client.query(
        'SELECT 1 FROM schema_migrations WHERE filename = $1',
        [file],
      );
      if (existing.rowCount) continue;

      const sql = await readFile(new URL(`../db/migrations/${file}`, import.meta.url), 'utf8');
      await client.query('BEGIN');
      try {
        if (typeof client.exec === 'function') {
          await client.exec(sql);
        } else {
          await client.query(sql);
        }
        await client.query(
          'INSERT INTO schema_migrations (filename) VALUES ($1)',
          [file],
        );
        await client.query('COMMIT');
        applied.push(file);
      } catch (error) {
        await client.query('ROLLBACK');
        throw error;
      }
    }

    return { applied, totalFiles: files.length };
  } finally {
    if (lockAcquired) {
      try {
        await client.query('SELECT pg_advisory_unlock(748391)');
      } catch {
        /* ignore unlock failure on exit */
      }
    }
    if (isPool) {
      client.release();
    }
  }
}

if (process.argv[1] && fileURLToPath(import.meta.url) === resolve(process.argv[1])) {
  try {
    const { applied } = await runMigrations();
    if (applied.length > 0) {
      for (const file of applied) {
        process.stdout.write(`Applied ${file}\n`);
      }
    } else {
      process.stdout.write('Database schema is already up to date.\n');
    }
  } finally {
    await pool?.end();
  }
}
