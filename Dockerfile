############################################################
# Dockerfile to build prestashop apache-php container image
# Based on phusion/baseimage
############################################################ 
# Set the base image to phusion/baseimage
# I used this image as they had a good description as to why they had created it
FROM phusion/baseimage:latest

# File Author / Maintainer
MAINTAINER Jonathan Temlett - Daedalus Solutions (jono@daedalus.co.za)

#Create the Environment Variable DEBIAN_FRONTEND to make sure we can build without failing because the install needs user inputs
ENV DEBIAN_FRONTEND noninteractive

# Update the repository sources list
RUN apt-get update

# We have to set the installation policy to "exit 0" which means it will allow the packages to restart services if they must.
RUN echo "exit 0" > /usr/sbin/policy-rc.d

#Install Apache Server software
RUN apt-get install -y apache2

# Create more environment variable to point to the apache folders
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

#Install php and apache php library
RUN apt-get install -y php5 libapache2-mod-php5

#Install php modules
RUN apt-get install -y php5-mysql 
#possible modules to add but not used here
#php5-curl php5-gd php5-intl php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-ming php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl

#Install php xcache - not used
#RUN apt-get install -y php5-xcache

#Prestashop setup
RUN cd /tmp
RUN apt-get install -y wget
RUN wget http://www.prestashop.com/download/old/prestashop_1.6.0.9.zip
RUN apt-get install -y unzip
RUN unzip prestashop_1.6.0.9.zip -d /var/www/html/
RUN chown -R www-data:www-data /var/www/html/prestashop/

# Expose the default port for web
EXPOSE 80

# Default port to execute the entrypoint (http://)
CMD ["-D", "FOREGROUND"]

# Set default container command
ENTRYPOINT ["/usr/sbin/apache2"]
