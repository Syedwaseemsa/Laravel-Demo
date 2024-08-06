# Use an official PHP runtime as a parent image
FROM php:8.2-fpm-alpine

# Set the working directory
WORKDIR /var/www

# Install system dependencies
RUN apk --no-cache add \
    git \
    curl \
    bash \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    zip \
    libzip-dev \
    oniguruma-dev \
    icu-dev \
    g++ \
    make \
    autoconf

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd intl zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy existing application directory contents
COPY . /var/www

# Set permissions
RUN chown -R www-data:www-data /var/www

# Change current user to www-data
USER www-data

# Expose port 8000 and start php-fpm server
EXPOSE 8000
CMD ["php-fpm"]

