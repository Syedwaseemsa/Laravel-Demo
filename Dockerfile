# Use the official PHP image with Apache
FROM php:8.0-apache

# Install PHP extensions
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Copy the application files
COPY . /var/www/html/

# Set working directory
WORKDIR /var/www/html

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Install application dependencies
RUN composer install

# Expose port 8000
EXPOSE 8000

# Update Apache configuration to listen on port 8000
RUN sed -i 's/Listen 80/Listen 8000/' /etc/apache2/ports.conf
RUN sed -i 's/<VirtualHost *:80>/<VirtualHost *:8000>/' /etc/apache2/sites-available/000-default.conf

# Start Apache
CMD ["apache2-foreground"]
