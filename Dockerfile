#https://mirrors.aliyun.com/alpine/
FROM php:7.4.10-fpm-alpine3.12

MAINTAINER lolfans <313273766@qq.com>

RUN echo '@community https://mirrors.aliyun.com/alpine/edge/community' >> /etc/apk/repositories


RUN apk update && apk upgrade && apk add \
	    php7-pdo_mysql@community \
	    php7-pdo_pgsql@community \
	    php7-phar@community \
	    php7-simplexml@community \
	    php7-mcrypt@community \
	    php7-xsl@community \
	    php7-zip@community \
	    php7-dom@community \
	    php7-redis@community\
	    php7-gd@community \
		&& rm -rf /var/cache/apk/*
	
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
