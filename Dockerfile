FROM php:7.4.20-apache

# Arguments defined
ARG COMPOSER_VERSION=2.4.4
ARG user=newuser
ARG uid=2312

RUN apt-get update && apt-get upgrade -y --force
# Install required files/packeges for extensions
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    zip \
    libpng-dev \
    libcurl4-openssl-dev \ 
    libonig-dev \
    libxml2-dev 

# Installing PHP extenions require for laravel 
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install zip
RUN docker-php-ext-install curl
RUN docker-php-ext-install xml
RUN docker-php-ext-install gd    
RUN docker-php-ext-install bcmath    
RUN docker-php-ext-install ctype    
RUN docker-php-ext-install fileinfo    
RUN docker-php-ext-install json     
RUN docker-php-ext-install mbstring   
RUN docker-php-ext-install pdo       
RUN docker-php-ext-install tokenizer        

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION}

# Copy the code to the container
# COPY . /var/www/html

# installing Laravel Global
RUN composer global require laravel/installer
# Install dependencies
# WORKDIR /var/www/html
# ENV COMPOSER_ALLOW_SUPERUSER=1
# RUN composer install --no-interaction --no-plugins --no-scripts --prefer-dist 

# Create system user to run Composer and Artisan Commands
# RUN useradd -G www-data,root -u $uid -d /home/$user $user
# RUN usermod -aG root,www-data $user


# RUN mkdir -p /home/$user/.composer && \
#     chown -R $user:$user /home/$user

# USER $user

# RUN composer install
RUN composer install 
# Set permissions
# RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
# RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache
