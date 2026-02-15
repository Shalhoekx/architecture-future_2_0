FROM node:20-slim AS builder

WORKDIR /app

# Копируем package.json
COPY package*.json ./

# Устанавливаем зависимости
RUN npm install

# Копируем остальные файлы
COPY . .

# Создаем папку .techradar и даем права
RUN mkdir -p .techradar && \
    chmod -R 777 .techradar

# Проверяем структуру
RUN ls -la

# Собираем проект
RUN npm run build

# Проверяем результат сборки
RUN ls -la build || ls -la .techradar/build

FROM nginxinc/nginx-unprivileged:1.25-alpine

# Копируем build из правильной папки
COPY --from=builder --chown=nginx:nginx /app/build /usr/share/nginx/html/techradar

RUN echo 'server { \
    listen 9080; \
    root /usr/share/nginx/html; \
    index index.html; \
    location /techradar { \
        alias /usr/share/nginx/html/techradar; \
        try_files $uri $uri/ /techradar/index.html; \
    } \
}' > /etc/nginx/conf.d/default.conf

EXPOSE 9080

CMD ["nginx", "-g", "daemon off;"]