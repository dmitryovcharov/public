FROM node:20-alpine as build

WORKDIR /app

COPY app/package*.json ./

RUN npm install

COPY app .

RUN npx open-next@3.1.3 build

FROM node:20-alpine as production

WORKDIR /app

COPY --from=build /app ./

RUN npm install --production

CMD ["npm", "start"]
