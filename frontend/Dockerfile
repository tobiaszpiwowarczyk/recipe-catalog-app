FROM node:latest

EXPOSE 4200

RUN mkdir app
WORKDIR /app

COPY package.json ./
RUN npm install -g npm
RUN npm install

COPY . .
CMD npm start