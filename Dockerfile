#https://mirrors.aliyun.com/alpine/
FROM php:7.4-fpm-alpine3.11

MAINTAINER lolfans <313273766@qq.com>

RUN echo '@community https://mirrors.aliyun.com/alpine/edge/community' >> /etc/apk/repositories
	
#NGINX
RUN apk add nginx

#SUPERVISOR
RUN apk add supervisor && rm -rf /var/cache/apk/*
	
#COMPOSER 
RUN curl -sS https://getcomposer.org/installer | \
php -- --install-dir=/usr/bin/ --filename=composer
	
	
COPY ./supervisor/conf.d /etc/supervisor/conf.d	
COPY ./crontabs/default /var/spool/cron/crontabs/


COPY ./php/index.php /var/www/html/
COPY ./php/php-fpm.conf /etc/php7/
COPY ./php/www.conf /etc/php7/php-fpm.d/

COPY ./nginx/default.conf /etc/nginx/conf.d/
#COPY ./nginx/ssl.default.config /etc/nginx/conf.d/
COPY ./nginx/nginx.conf /etc/nginx/

WORKDIR /var/www/html/


ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisor/conf.d/supervisord.conf"]
