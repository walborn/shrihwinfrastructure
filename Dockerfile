# Install dependencies only when needed
FROM node:16 AS deps

WORKDIR /opt/app
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Rebuild the source code only when needed
# This is where because may be the case that you would try
# to build the app based on some `X_TAG` in my case (Git commit hash)
# but the code hasn't changed.
FROM node:16 AS builder

ENV NODE_ENV=production
WORKDIR /opt/app
COPY . .
COPY --from=deps /opt/app/node_modules ./node_modules
RUN yarn build

# Production image, copy all the files and run next
FROM node:16 AS runner

ARG X_TAG
WORKDIR /opt/app
ENV NODE_ENV=production
# COPY --from=builder /opt/app/next.config.js ./
COPY --from=builder /opt/app/public ./public
COPY --from=builder /opt/app/.next ./.next
COPY --from=builder /opt/app/node_modules ./node_modules
CMD ["node_modules/.bin/next", "start"]


# # Install dependencies only when needed
# FROM node:16 AS deps
# WORKDIR /app
# COPY package.json yarn.lock ./
# RUN yarn install --frozen-lockfile

# # Rebuild the source code only when needed
# FROM node:16 AS builder
# WORKDIR /app
# COPY . .
# COPY --from=deps /app/node_modules ./node_modules
# RUN yarn build
# RUN yarn install --production --ignore-scripts --prefer-offline

# # Production image, copy all the files and run next
# FROM node:16 AS runner
# WORKDIR /app

# ENV NODE_ENV production

# COPY --from=builder /app/public ./public
# COPY --from=builder --chown=nextjs:nodejs /app/.next ./.next
# COPY --from=builder /app/node_modules ./node_modules
# COPY --from=builder /app/package.json ./package.json

# CMD ["yarn", "start"]

# # Production image, copy all the files and run next
# FROM node:14-alpine AS runner
# WORKDIR /app

# ARG APP_ENV=production
# ARG NODE_ENV=production
# ARG PORT=3000

# ENV APP_ENV=${APP_ENV} \
#     NODE_ENV=${NODE_ENV} \
#     PORT=${PORT} \
#     # This allows to access Graphql Playground
#     APOLLO_PRODUCTION_INTROSPECTION=false

# RUN addgroup -g 1001 -S nodejs
# RUN adduser -S nextjs -u 1001

# RUN mkdir -p /app/.next/cache/images && chown nextjs:nodejs /app/.next/cache/images
# VOLUME /app/.next/cache/images

# # You only need to copy next.config.js if you are NOT using the default configuration
# # COPY --from=builder /app/next.config.js ./
# COPY --from=builder /app/public ./public
# COPY --from=builder --chown=nextjs:nodejs /app/.next ./.next
# COPY --from=builder /app/node_modules ./node_modules
# COPY --from=builder /app/package.json ./package.json

# USER nextjs

# EXPOSE ${PORT}

# # Next.js collects completely anonymous telemetry data about general usage.
# # Learn more here: https://nextjs.org/telemetry
# # Uncomment the following line in case you want to disable telemetry.
# # ENV NEXT_TELEMETRY_DISABLED 1

# CMD ["yarn", "start"]