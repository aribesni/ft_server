#INSTALL DEBIAN BUSTER
FROM debian:buster


#USER
MAINTAINER aribesni <aribesni@student.42.fr>


#UPDATES
RUN apt-get update && apt-get -y upgrade


#UTILS
RUN apt-get -y install wget vim


#INSTALL NGINX
RUN apt-get -y install nginx

COPY srcs/default /etc/nginx/sites-enabled/


#INSTALL MYSQL SERVER
RUN apt-get -y install mariadb-server


#LINK NGINX AND PHP
RUN apt-get -y install php-fpm php-mysql php-mbstring php-zip php-gd php-xml php-pear php-gettext php-cli php-json


#INSTALL PHPMYADMIN
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-english.tar.gz

RUN mkdir /var/www/html/phpmyadmin && tar xvf phpMyAdmin-4.9.0.1-english.tar.gz --strip-components=1 -C /var/www/html/phpmyadmin && rm -f phpMyAdmin-4.9.0.1-english.tar.gz

COPY srcs/config.inc.php /var/www/html/phpmyadmin/

RUN chmod 660 /var/www/html/phpmyadmin/config.inc.php && rm -f /var/www/html/config.sample.inc.php && chown -R www-data:www-data /var/www/html/phpmyadmin


#INSTALL WORDPRESS
RUN apt-get -y install php-curl php-intl php-soap php-xmlrpc php-zip

COPY srcs/wordpress.conf /etc/nginx/sites-available/

RUN ln -s /etc/nginx/sites-available/wordpress.conf /etc/nginx/sites-enabled/

RUN wget https://wordpress.org/latest.tar.gz && mkdir /var/www/html/wordpress && tar xzf latest.tar.gz --strip-components=1 -C /var/www/html/wordpress && rm -f latest.tar.gz

COPY srcs/wp-config.php /var/www/html/wordpress/

RUN rm -f /var/www/html/wordpress/wp-config.sample.php

COPY srcs/create_db.sql ./

RUN service mysql start && mysql -h localhost -u root -proot < create_db.sql

RUN chown -R www-data:www-data /var/www/html/wordpress/


#GENERATE SSL
RUN apt-get install openssl

RUN mkdir /etc/nginx/ssl

COPY ./srcs/ssl.crt /etc/nginx/ssl
COPY ./srcs/ssl.key /etc/nginx/ssl

#RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 3650 -nodes -out /etc/nginx/ssl/localhost.crt -keyout /etc/nginx/ssl/localhost.key -subj "/C=FR/ST=Paris/L=Paris/O=42/OU=School/CN=localhost"


COPY srcs/script_debian.sh ./


EXPOSE 80 443


CMD /bin/bash script_debian.sh && sleep infinity

