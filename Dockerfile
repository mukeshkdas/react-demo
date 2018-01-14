FROM node:8-alpine
WORKDIR /home/reactapp
ADD . .
EXPOSE 3000
ENTRYPOINT ["npm", "start"]
