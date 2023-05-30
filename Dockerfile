# Stage 1: Build stage
FROM node:14 as build-stage

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

# Stage 2: Production stage
FROM node:14-alpine as production-stage

WORKDIR /app

COPY --from=build-stage /app/package*.json ./
COPY --from=build-stage /app/.output ./.output

RUN npm install --only=production

EXPOSE 3000

CMD [ "node", ".output/server/index.mjs" ]