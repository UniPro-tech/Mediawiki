FROM node:20-alpine

WORKDIR /nextjs

COPY . .

RUN rm -rf node_modules
RUN rm -rf .next
RUN npm install
RUN npm run build

CMD ["npm", "start"]