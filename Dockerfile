FROM php:8.4-apache

RUN apt-get update && apt-get install -y \
    libicu-dev \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl


# Atualizar pacotes e instalar dependências necessárias
RUN apt-get update && apt-get install -y \
    wget \
    g++ \
    curl \
    git \
    gnupg2 \
    apt-utils \
    software-properties-common \
    libpng-dev \
    libzip-dev \
    unzip \
    libpq-dev \
    zip \
    nano \
    vim \
    apache2-utils \
    pwgen \
    htop

# Habilitar extensões do PHP necessárias para o Adianti Framework
RUN docker-php-ext-install \
    gd \
    mysqli \
    mbstring \
    pdo_mysql \
    pdo_pgsql \
    zip \
    opcache \
    gd \
    soap \
    xml \
    sockets \
    intl 

# Instalar o Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Alias para rodar o Composer sem configurações extras
RUN alias composer="php -n /usr/local/bin/composer"

RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html
    
# Ativar o mod_rewrite do Apache (necessário para o Adianti Framework)
RUN a2enmod rewrite

# Configuração do ambiente de trabalho
WORKDIR /var/www/html

# Expor porta padrão do Apache
EXPOSE 80
