FROM php:8.4-apache

RUN apt-get update && apt-get install -y \
    libicu-dev \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && a2enmod rewrite \
    && a2dismod mpm_event \
    && a2dismod mpm_worker \
    && a2enmod mpm_prefork

# Atualizar pacotes e instalar dependências necessárias
RUN apt-get update && apt-get install -y \
    wget \
    rpl \
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

RUN docker-php-ext-install pdo  pdo_mysql  pdo_pgsql  mbstring  opcache  gd  soap  xml    sockets  
 

RUN echo "" >> /usr/local/etc/php/php.ini && \  
    echo "error_log = /tmp/php_errors.log" >> /usr/local/etc/php/php.ini && \
    echo "log_errors = On" >> /usr/local/etc/php/php.ini && \
    echo "display_errors = Off" >> /usr/local/etc/php/php.ini && \
    echo "memory_limit = 256M" >> /usr/local/etc/php/php.ini && \
    echo "max_execution_time = 120" >> /usr/local/etc/php/php.ini && \
    echo "error_reporting = E_ALL" >> /usr/local/etc/php/php.ini && \
    echo "file_uploads = On" >> /usr/local/etc/php/php.ini && \
    echo "post_max_size = 100M" >> /usr/local/etc/php/php.ini && \
    echo "upload_max_filesize = 100M" >> /usr/local/etc/php/php.ini && \
    echo "session.gc_maxlifetime = 14000" >> /usr/local/etc/php/php.ini  && \
    echo "session.name = CUSTOMSESSID"   >> /usr/local/etc/php/php.ini  && \
    echo "session.use_only_cookies = 1"        >> /usr/local/etc/php/php.ini  && \
    echo "session.cookie_httponly = 1"      >> /usr/local/etc/php/php.ini  && \
    echo "session.cookie_secure = 1"      >> /usr/local/etc/php/php.ini  && \
    echo "session.cookie_samesite  = Strict"      >> /usr/local/etc/php/php.ini  && \
    echo "session.use_trans_sid = 0"           >> /usr/local/etc/php/php.ini  && \
    echo "session.entropy_file = /dev/urandom" >> /usr/local/etc/php/php.ini  && \
    echo "session.entropy_length = 32"         >> /usr/local/etc/php/php.ini     

RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

RUN rm /etc/apache2/mods-enabled/evasive.conf   && \
    echo '<IfModule mod_evasive20.c>'             >> /etc/apache2/mods-enabled/evasive.conf && \
    echo '  DOSHashTableSize 2048'                >> /etc/apache2/mods-enabled/evasive.conf && \
    echo '  DOSPageCount 10'                      >> /etc/apache2/mods-enabled/evasive.conf && \
    echo '  DOSSiteCount 200'                     >> /etc/apache2/mods-enabled/evasive.conf && \
    echo '  DOSPageInterval 2'                    >> /etc/apache2/mods-enabled/evasive.conf && \
    echo '  DOSSiteInterval 2'                    >> /etc/apache2/mods-enabled/evasive.conf && \
    echo '  DOSBlockingPeriod 10'                 >> /etc/apache2/mods-enabled/evasive.conf && \
    echo '  DOSLogDir "/var/log/apache2/evasive"' >> /etc/apache2/mods-enabled/evasive.conf && \
    echo '</IfModule>'                            >> /etc/apache2/mods-enabled/evasive.conf 

RUN rpl "AllowOverride None" "AllowOverride All" /etc/apache2/apache2.conf
    
# Ativar o mod_rewrite do Apache (necessário para o Adianti Framework)
#RUN a2enmod rewrite

# Configuração do ambiente de trabalho
WORKDIR /var/www/html

# Expor porta padrão do Apache
EXPOSE 80
