# stage1 as builder
FROM node:20.13.1-alpine3.19 as builder
# Copy the package.json and install dependencies
COPY package*.json ./
RUN npm install
# Copy rest of the files
COPY . .
# Build the project
RUN npm run build

FROM nginx:1.26.0-alpine3.19 as production-build
# Copy from the stage 1
COPY --from=builder /dist /usr/share/nginx/html
# Copy the nginx configuration file
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
EXPOSE 8080
ENTRYPOINT ["nginx", "-g", "daemon off;"]