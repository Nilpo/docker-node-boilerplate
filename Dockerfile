# ---- Base Node ----
FROM node:carbon AS base

# Create app directory
WORKDIR /app

# Set a PORT environment variable
ENV PORT=5000
EXPOSE 5000


# ---- Dependencies ----
FROM base AS dependencies

# Install nodemon for hot reload
RUN npm install --save-dev nodemon

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

# install app dependencies including 'devDependencies'
ENV NODE_ENV=development
RUN npm install


# ---- Development ----
FROM dependencies AS dev

# Copy app sources
COPY src /app

RUN npm run dev
CMD [ "nodemon", "server.js"]


# ---- Build ----
FROM dependencies AS build

# Copy app sources
COPY src /app

# Build bundled static files
RUN npm run build


# ---- Release with Alpine ----
FROM node:15-alpine AS release
WORKDIR /app
# RUN npm -g install serve
COPY --from=dependencies /app/package.json ./
ENV NODE_ENV=production
RUN npm install --only-production
COPY --from=build /app ./
# CMD [ "serve", "-s", "dist", "-p", "5000" ]
CMD [ "node", "server.js" ]

# $ cd docker-node-boilerplate
# $ docker build --target dev -t docker-node-dev
# $ docker run --rm -it --init -p 5000:5000 -v $(pwd):/app docker-node-dev bash
# root@id:/app# nodemon src/server.js
# $ docker run -d --rm -it --init -p 5000:5000 docker-node-live