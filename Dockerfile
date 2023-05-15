FROM centos
COPY ecommerce-master /var/www/html/ecommerce
RUN yum update -y 
RUN yum install -y httpd wget php-fpm php-mysqli php-json php php-devel
CMD ["httpd", "-D", "FOREGROUND"]
