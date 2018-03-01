FROM node:8-alpine
MAINTAINER Sushanth Mangalore <sushanth.mlr@gmail.com>

WORKDIR /home/reactapp

ADD . .

EXPOSE 3000

ENTRYPOINT ["npm", "start"]
