FROM centos:7
MAINTAINER Arnaw <arnaw@spenmo.com>

# Update library
RUN yum -y update

# Install systemctl
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

# Install all tools
RUN yum -y install epel-release
RUN yum -y install nginx
RUN yum -y install net-tools
RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

# Adding the configuration file of the nginx
ADD Libraries/nginx.conf /etc/nginx/nginx.conf
ADD Libraries/default.conf /etc/nginx/conf.d/default.conf

# Adding the configuration file of the Supervisor
ADD Libraries/supervisord.conf /etc/

# Install php and related requirements
RUN yum install -y php71w php71w-curl php71w-common php71w-cli php71w-mysql php71w-mbstring php71w-fpm php71w-xml php71w-pdo php71w-zip

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# Set configurations to pre-existing files
COPY Libraries/php.ini /etc/php.ini
COPY Libraries/www.conf /etc/php-fpm.d/www.conf

# Set Environment, and code
COPY . /var/www

#Init
CMD ["/usr/sbin/init"]

# Set entrypoint script
#COPY Libraries/docker-entrypoint.sh /usr/local/bin/
#RUN chmod +x /usr/local/bin/docker-entrypoint.sh
#RUN ln -s /usr/local/bin/docker-entrypoint.sh / # backwards compat
#ENTRYPOINT ["docker-entrypoint.sh"]


# Set the port to 80 
EXPOSE 80

