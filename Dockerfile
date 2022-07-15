FROM node:16.16.0

ADD ./ ./

RUN npm install && npm run build

ENV NODE_ENV "production"

EXPOSE 3000 443

CMD ["npm", "run", "start"]
