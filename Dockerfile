
FROM php:8.1-apache

# Install necessary libraries
RUN apt-get update && apt-get install -y \
    libonig-dev \
    libzip-dev

# Install PHP extensions
RUN docker-php-ext-install \
    mbstring \
    zip

# Copy Laravel application
COPY . /var/www/html

# Set working directory
WORKDIR /var/www/html

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install dependencies
RUN composer install

# Change ownership of our applications
RUN chown -R www-data:www-data /var/www/html

# Install mbstring extension again for Laravel
RUN docker-php-ext-install mbstring

# Copy .env.example to .env
COPY .env.example .env

# Generate a new application key
RUN php artisan key:generate

# Expose port 80
EXPOSE 80

# Enable Apache rewrite module
RUN a2enmod rewrite

# Copy Apache configuration file
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf
