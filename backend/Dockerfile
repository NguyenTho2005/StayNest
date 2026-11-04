# StayNest Backend API (Node.js + Express)
FROM node:20-alpine AS runner

WORKDIR /app

# Install curl for container healthcheck
RUN apk add --no-cache curl

# Install production dependencies
COPY backend/package*.json ./
RUN npm ci --omit=dev

# Copy application source code and migrations
COPY backend/src ./src
COPY backend/db ./db
COPY backend/supabase-ca.crt* ./

# Copy media assets so Express static route resolves correctly
COPY assets/images /assets/images

EXPOSE 3000

ENV NODE_ENV=production \
    PORT=3000 \
    HOST=0.0.0.0

HEALTHCHECK --interval=20s --timeout=5s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/api/v1/health || exit 1

CMD ["node", "src/server.js"]

