FROM php:7.4.10-fpm-alpine3.12

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk add --no-cache autoconf g++ libtool make curl-dev libxml2-dev linux-headers

RUN docker-php-source extract \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install calendar \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install sockets \
    && docker-php-ext-install exif \
    && apk add --no-cache gettext-dev && docker-php-ext-install gettext \
    && apk add --no-cache bzip2-dev && docker-php-ext-install bz2 \
    && rm -rf /var/cache/apk/* \
    && docker-php-source delete
	
#RUN pecl install redis \
#	&& pecl install memcached \
#	&& docker-php-ext-enable redis memcached

#NGINX
RUN apk add nginx

#SUPERVISOR
RUN apk add supervisor && rm -rf /var/cache/apk/*
	
#COMPOSER china-speed
RUN curl -sS http://getcomposer.org.mirrors.china-speed.org.cn/installer | \
php -- --install-dir=/usr/bin/ --filename=composer
	
COPY ./supervisor/conf.d /etc/supervisor/conf.d	
COPY ./crontabs/default /var/spool/cron/crontabs/

#COPY ./php/index.php /var/www/html/
#COPY ./php/php-fpm.conf /etc/php7/
#COPY ./php/www.conf /etc/php7/php-fpm.d/

RUN mkdir -p /run/nginx
#COPY ./nginx/default.conf /etc/nginx/conf.d/
#COPY ./nginx/ssl.default.conf /etc/nginx/conf.d/
#COPY ./nginx/nginx.conf /etc/nginx/

WORKDIR /var/www/html/


ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisor/conf.d/supervisord.conf"]
