export function fail(status, code, message) {
  const error = new Error(message);
  error.status = status;
  error.code = code;
  return error;
}

export function requireText(value, field, max = 255) {
  if (typeof value !== 'string' || !value.trim() || value.trim().length > max) {
    throw fail(400, 'INVALID_INPUT', `${field} is required and must be at most ${max} characters`);
  }
  return value.trim();
}

export function positiveInt(value, field, max = 100) {
  if (!Number.isInteger(value) || value < 1 || value > max) {
    throw fail(400, 'INVALID_INPUT', `${field} must be an integer from 1 to ${max}`);
  }
  return value;
}

export function route(handler) {
  return (request, response, next) => Promise.resolve(handler(request, response, next)).catch(next);
}
