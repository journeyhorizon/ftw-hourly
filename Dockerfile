FROM node:16.13.1

ADD ./ ./

ENV NODE_ENV "production"

EXPOSE 3000 443

CMD ["npm", "run", "start"]
