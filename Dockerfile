FROM php:7.4-apache

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    unzip \
    curl \
    git \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libicu-dev \
    libgettextpo-dev \
    libonig-dev \
    zlib1g-dev \
    libxml2-dev \
    libxslt1-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
        pdo \
        pdo_mysql \
        mysqli \
        zip \
        gd \
        intl \
        gettext \
        bcmath

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy app files
COPY . /var/www/html/

# Set working directory
WORKDIR /var/www/html/

# Run composer to install dependencies
RUN composer install --no-dev --prefer-dist --optimize-autoloader

# Set permissions
RUN chown -R www-data:www-data /var/www/html

# Expose port
EXPOSE 80
