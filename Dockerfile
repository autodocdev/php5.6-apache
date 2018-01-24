FROM autodoc/ubuntu-base:latest

MAINTAINER Danilo Correa <danilosilva87@gmail.com>

USER root

RUN add-apt-repository -y -u ppa:ondrej/php && \
    apt-get update -y --no-install-recommends && \
    curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get install -y \
    php5.6 \
    php5.6-cli \
    php5.6-common \
    php5.6-curl \
    php5.6-gd \
    php5.6-gmp \
    php5.6-imap \
    php5.6-mbstring \
    php5.6-mcrypt \
    php5.6-pgsql \
    php5.6-opcache \
    php5.6-mysql \
    php5.6-soap \
    php5.6-xmlrpc \
    php5.6-xml \
    php5.6-sqlite3 \
    php5.6-xsl \ 
    php5.6-zip \
    php5.6-dev \
    php-memcached \
    php-pear \
    libapache2-mod-php5.6 \
    nodejs \
    apache2 && \
    npm install -g bower && \
    pecl install gRPC

ENV APACHE_RUN_USER application
ENV APACHE_RUN_GROUP application
ENV APACHE_SERVER_NAME localhost
ENV APACHE_HTTP_PORT 8888

ADD ./php.ini /etc/php/5.6/apache2
ADD ./php.ini /etc/php/5.6/cli
ADD ./envvars /etc/apache2/

COPY sites-enabled/*.conf /etc/apache2/sites-enabled/

RUN a2enmod rewrite ssl

RUN \
    curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/local/bin --filename=composer

RUN \
    curl -LO https://deployer.org/releases/v4.3.1/deployer.phar && \
    mv deployer.phar /usr/local/bin/dep && \
    chmod +x /usr/local/bin/dep

RUN \
    curl -LO https://phar.phpunit.de/phpunit-5.7.phar && \
    chmod +x phpunit-5.7.phar && \
    mv phpunit-5.7.phar /usr/local/bin/phpunit

RUN ln -sf /dev/stdout /var/log/apache2/access.log
RUN ln -sf /dev/stderr /var/log/apache2/error.log    

EXPOSE 8888

WORKDIR /home/application

CMD /usr/sbin/apache2ctl -D FOREGROUND
