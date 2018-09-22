FROM composer as development

# Needed for DB migrations.
RUN apk add --update mariadb netcat-openbsd
RUN docker-php-ext-install mysqli pdo pdo_mysql

WORKDIR /app

# Configure PHP to allow larger file uploads, songs are big!
RUN echo "upload_max_filesize = 6M" > /usr/local/etc/php/conf.d/fileuploads.ini

# Install deps
#COPY database app tests composer.json composer.lock ./
COPY . .
RUN composer install

# Allow startup script to be executed
RUN chmod +x /app/docker-start.sh
# Allow public to be served
RUN chmod -R 766 /app/storage
CMD ["/app/docker-start.sh"]
