# 1단계: 빌드 (Node.js 사용)
FROM node:18-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# Vite 사용 시
RUN npm run build

# 2단계: 실행 (Nginx 사용)
FROM nginx:alpine
# Vite → dist 폴더, CRA(Create React App) → build 폴더
COPY --from=build /app/dist /usr/share/nginx/html
# COPY --from=build /app/build /usr/share/nginx/html   # CRA라면 이걸 사용

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
