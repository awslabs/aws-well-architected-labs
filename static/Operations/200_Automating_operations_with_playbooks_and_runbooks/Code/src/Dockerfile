FROM node:12-slim

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./
# ENV NODE_ENV=production
# If you are building your code for production
# RUN npm ci --only=production
ENV NODE_ENV=production
RUN npm install

# Bundle app source
COPY . .

EXPOSE 80
CMD [ "node", "app.js" ]