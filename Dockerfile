# 1. Install dependencies and build
FROM node:18-alpine AS builder

WORKDIR /app

# Enable corepack (comes with Node >=16.13)
RUN corepack enable

COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

COPY . .
RUN pnpm build

# 2. Use a lightweight image for runtime
FROM node:18-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production
ENV PORT=3000

# Enable corepack again in runtime
RUN corepack enable

COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./

EXPOSE 3000

CMD ["pnpm", "start"]