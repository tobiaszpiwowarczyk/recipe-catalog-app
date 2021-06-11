FROM node:latest

EXPOSE 3000

RUN mkdir /app
VOLUME [ "/app" ]

WORKDIR /app
COPY package.json .
COPY src/ .

RUN npm install

CMD ["npm", "start"]