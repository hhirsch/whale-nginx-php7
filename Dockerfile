FROM alpine:3.5

RUN apk --update add \
  nginx \
  php7-fpm \
  php7-pdo \
  php7-json \
  php7-openssl \
  php7-mysqlnd \
  php7-pdo_mysql \
  php7-mcrypt \
  php7-sqlite3 \
  php7-pdo_sqlite \
  php7-ctype \
  php7-zlib \
  php7-curl \
  php7-soap \
  php7-mysqli \
  php7-phar \
  php7-xml \
  php7-opcache \
  php7-intl \
  php7-bcmath \
  php7-dom \
  php7-xmlreader \
  php7-iconv \
  php7-gd \
  curl \
  supervisor \
  && rm -rf /var/cache/apk/*

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer
RUN mkdir -p /etc/nginx
RUN mkdir -p /var/run/php-fpm
RUN mkdir -p /var/log/supervisor
RUN mkdir -p /etc/ssl/certs;
RUN mkdir -p /etc/ssl/private;
RUN rm /etc/nginx/nginx.conf
RUN rm /etc/php/php-fpm.conf
RUN deluser xfs
RUN delgroup www-data
RUN adduser -u 33 -h /var/www -g "" -D  www-data
ADD nginx.conf /etc/nginx/nginx.conf
ADD php-fpm.conf /etc/php/php-fpm.conf

RUN ln -sf /dev/stdout /var/log/access.log && \
    ln -sf /dev/stderr /var/log/error.log

VOLUME ["/var/www", "/etc/nginx/sites-enabled", "/etc/nginx/sites-available", "/var/log/nginx"]

ADD supervisor.ini /etc/supervisor.d/nginx-supervisor.ini

EXPOSE 8080

CMD ["/usr/bin/supervisord"]
