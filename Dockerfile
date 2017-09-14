FROM autodoc/ubuntu-base:latest

MAINTAINER Danilo Correa <danilosilva87@gmail.com>

RUN add-apt-repository -y -u ppa:ondrej/php && \
    apt-get update -y --no-install-recommends && \
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
    php-memcached \
    libapache2-mod-php5.6 \
    apache2

RUN a2enmod rewrite ssl

ADD ./php.ini /etc/php/5.6/apache2
ADD ./php.ini /etc/php/5.6/cli

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

EXPOSE 80 443

WORKDIR ~/

USER aplication

CMD /usr/sbin/apache2ctl -D FOREGROUND
