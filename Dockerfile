FROM alpine:3.3

RUN apk --update add \
  nginx \
  php-fpm \
  php-pdo \
  php-json \
  php-openssl \
  php-mysql \
  php-pdo_mysql \
  php-mcrypt \
  php-sqlite3 \
  php-pdo_sqlite \
  php-ctype \
  php-zlib \
  php-curl \
  php-phar \
  php-xml \
  php-opcache \
  php-intl \
  php-bcmath \
  php-dom \
  php-xmlreader \
  php-iconv \
  php-gd \
  curl \
  supervisor \
  shadow \
  && rm -rf /var/cache/apk/*

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer
RUN useradd -u 33 www-data
RUN mkdir -p /etc/nginx
RUN mkdir -p /var/run/php-fpm
RUN mkdir -p /var/log/supervisor
RUN mkdir -p /etc/ssl/certs;
RUN mkdir -p /etc/ssl/private;
RUN rm /etc/nginx/nginx.conf
ADD nginx.conf /etc/nginx/nginx.conf

RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

VOLUME ["/var/www", "/etc/nginx/sites-enabled", "/etc/nginx/sites-available", "/var/log/nginx"]

ADD supervisor.ini /etc/supervisor.d/nginx-supervisor.ini

EXPOSE 8080

CMD ["/usr/bin/supervisord"]
