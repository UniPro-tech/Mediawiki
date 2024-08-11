# yuitoengineer/mediawiki
FROM php:8.1-apache

# System dependencies
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    unzip \
    git \
    librsvg2-bin \
    imagemagick \
    python3 \
    libicu-dev \
    libonig-dev \
    gnupg \
    dirmngr \
    libssl-dev \
    ; \
    docker-php-ext-install -j "$(nproc)" \
    calendar \
    intl \
    mbstring \
    mysqli \
    opcache \
    ; \
    pecl install APCu-5.1.21; \
    docker-php-ext-enable apcu; 

# Enable Short URLs
COPY apacheconf.conf $APACHE_CONFDIR/conf-available/mediawiki.conf
RUN a2enconf mediawiki

# Set recommended PHP.ini settings
RUN { \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=4000'; \
    \
    echo 'opcache.revalidate_freq=60'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini

# SQLite Directory Setup
RUN set -eux; \
    mkdir -p /var/www/data; \
    chown -R www-data:www-data /var/www/data

# Version
ENV MEDIAWIKI_MAJOR_VERSION 1.42
ENV MEDIAWIKI_VERSION 1.42.1
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN set -eux; \
    fetchDeps=" \
    gnupg \
    dirmngr \
    "; \
    apt-get update; \
    apt-get install -y --no-install-recommends $fetchDeps; \
    \
    curl -fSL "https://releases.wikimedia.org/mediawiki/${MEDIAWIKI_MAJOR_VERSION}/mediawiki-${MEDIAWIKI_VERSION}.tar.gz" -o mediawiki.tar.gz; \
    curl -fSL "https://releases.wikimedia.org/mediawiki/${MEDIAWIKI_MAJOR_VERSION}/mediawiki-${MEDIAWIKI_VERSION}.tar.gz.sig" -o mediawiki.tar.gz.sig; \
    export GNUPGHOME="$(mktemp -d)"; \
    # gpg key from https://www.mediawiki.org/keys/keys.txt
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys \
    D7D6767D135A514BEB86E9BA75682B08E8A3FEC4 \
    441276E9CCD15F44F6D97D18C119E1A64D70938E \
    F7F780D82EBFB8A56556E7EE82403E59F9F8CD79 \
    1D98867E82982C8FE0ABC25F9B69B3109D3BB7B0 \
    ; \
    gpg --batch --verify mediawiki.tar.gz.sig mediawiki.tar.gz; \
    tar -x --strip-components=1 -f mediawiki.tar.gz; \
    gpgconf --kill all; \
    rm -r "$GNUPGHOME" mediawiki.tar.gz.sig mediawiki.tar.gz; \
    chown -R www-data:www-data extensions skins cache images;

# Install MediaWiki extensions
RUN set -eux; \
    cd /var/www/html/extensions; \
    git clone https://gerrit.wikimedia.org/r/mediawiki/extensions/Babel --branch REL1_42; \
    cd Babel; git submodule update --init; cd /var/www/html/extensions; \
    git clone https://gerrit.wikimedia.org/r/mediawiki/extensions/Disambiguator --branch REL1_42; \
    cd Disambiguator; git submodule update --init; cd /var/www/html/extensions; \
    git clone https://gerrit.wikimedia.org/r/mediawiki/extensions/NewUserMessage --branch REL1_42; \
    cd NewUserMessage; git submodule update --init; cd /var/www/html/extensions; \
    git clone https://gerrit.wikimedia.org/r/mediawiki/extensions/CheckUser --branch REL1_42; \
    cd CheckUser; git submodule update --init; cd /var/www/html/extensions; \
    git clone https://gerrit.wikimedia.org/r/mediawiki/extensions/TemplateStyles --branch REL1_42; \
    cd TemplateStyles; git submodule update --init; cd /var/www/html/extensions; 

# RUN cd /var/www/html/extensions; \
#     git clone https://gerrit.wikimedia.org/r/mediawiki/extensions/SwiftMailer --branch REL1_41; \
#     cd SwiftMailer; git submodule update --init; cd /var/www/html/extensions;

# Install Composer
RUN curl -s https://getcomposer.org/installer | php; \
    mv composer.phar /usr/local/bin/composer; \
    chmod +x /usr/local/bin/composer

COPY composer.local.json /var/www/html/composer.local.json
RUN cd /var/www/html; composer install; composer update

# RUN composer require phpmailer/phpmailer
# COPY mailsender.php /var/www/html/mailsender.php

# COPY extension.json /var/www/html/extensions/SwiftMailer/extension.json

RUN a2enmod rewrite
RUN a2enmod ssl

CMD ["apache2-foreground"]
