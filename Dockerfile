FROM ubuntu:latest
#the following ARG turns off the questions normally asked for location and timezone for Apache
ENV DEBIAN_FRONTEND=noninteractive
#install all the tools you might want to use in your container
#probably should change to apt-get install -y --no-install-recommends
RUN apt-get update
#RUN apt upgrade -y
RUN apt-get install -y nano
RUN apt-get install git -y
RUN apt-get install zip unzip -y
RUN apt-get install -y apache2
RUN apt-get install libapache2-mod-fcgid
RUN a2enmod proxy
RUN a2enmod proxy_fcgi

# Install PHP-fpm &onfigure Apache to use our PHP-FPM socket for all PHP files
RUN apt-get install -y \
 php7.4-fpm \
  php7.4-mbstring \
  php7.4-dom 
RUN a2enconf php7.4-fpm
RUN phpenmod opcache 
RUN phpenmod pdo
RUN phpenmod bcmath 
     
RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer 

# Now start the server
# Start PHP-FPM worker service and run Apache in foreground
EXPOSE 80
CMD service php7.4-fpm start && /usr/sbin/apache2ctl -D FOREGROUND





WORKDIR /opt/app


#set working directory to where Apache serves files
RUN chown -R www-data:www-data /opt/app
WORKDIR /opt/app/
RUN rm -rf /var/www/html
RUN	ln -sf /opt/app/ /var/www/html
RUN echo "<?php phpinfo() ?>" >> info.php
