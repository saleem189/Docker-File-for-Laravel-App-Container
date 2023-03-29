FROM php:7.4.20-apache

# Install required dependences

RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    zip \
    libpng-dev \
    libcurl4-openssl-dev \ 
    libonig-dev \
    libxml2-dev \
    libmagickwand-dev \
    --no-install-recommends \
    && pecl install imagick \
    && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/* 

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
RUN docker-php-ext-install pdo_mysql       
RUN docker-php-ext-install tokenizer  
RUN docker-php-ext-enable imagick opcache       

# Update apache conf to point to application public directory
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# add this line to suppress the warning message
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf  

# Update uploads config
RUN echo "file_uploads = On\n" \
         "memory_limit = 1024M\n" \
         "upload_max_filesize = 512M\n" \
         "post_max_size = 512M\n" \
         "max_execution_time = 1200\n" \
         > /usr/local/etc/php/conf.d/uploads.ini


# Enable headers module
RUN a2enmod rewrite headers 

# Install composer
ARG COMPOSER_VERSION=2.4.4
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION}

# Copy the code to the container
# COPY . /var/www/html

# installing Laravel Global
RUN composer global require laravel/installer

# Set image tags
LABEL maintainer="Saleem Ayoub Khan saleemayoub1@gmail.com"
LABEL php-version="7.4.20"
LABEL apache-version="2.4.38"
LABEL imagick-version="3.4.4"
LABEL composer-version="2.4.4"
