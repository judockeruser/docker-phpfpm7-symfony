FROM centos:7
MAINTAINER Stellan Nordenbro <stellan.nordenbro@ju.se>
# Add IUS repository for PHP and update
RUN yum localinstall -y https://centos7.iuscommunity.org/ius-release.rpm && yum update -y
# Install PHP and modules
RUN yum install -y php70u-cli php70u-fpm php70u-common
RUN yum install -y php70u-mcrypt php70u-ldap php70u-mbstring \
                   php70u-pdo php70u-pgsql php70u-pear php70u-pecl-apcu php70u-gd \
                   php70u-intl php70u-bcmath php70u-devel php70u-process php70u-pspell  \
                   php70u-recode  php70u-tidy php70u-xml php70u-xmlrpc php70u-opcache \
                   php70u-json php70u-pecl-xdebug php70u-pecl-apcu \
                   git curl vim node npm make automake epel-release

# Add postgres client
RUN sed -i 's/RPM-GPG-KEY-CentOS-7/RPM-GPG-KEY-CentOS-7\nexclude=postgresql*/g' /etc/yum.repos.d/CentOS-Base.repo && \
    yum localinstall -y https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-redhat96-9.6-3.noarch.rpm && yum update -y && \
    yum install -y postgresql96

# Add configurations
ADD ./conf/symfony.ini /etc/php.d/10-symfony.ini

# Install utilities (xdebug is used by CI and Dev
RUN curl -o /usr/local/bin/phpunit https://phar.phpunit.de/phpunit-5.2.3.phar && chmod +x /usr/local/bin/phpunit
RUN cd /usr/local/bin && curl -sS https://getcomposer.org/installer | php -- --filename=composer
RUN npm install -g bower uglifyjs uglifycss grunt-cli

# Container configuration
WORKDIR /var/www/symfony

# Dummy startup script
COPY ./scripts/entrypoint.sh /entrypoint.sh
COPY ./scripts/control/pause /pause
COPY ./scripts/control/resume /resume
COPY ./scripts/control/restart /restart

EXPOSE 9000
RUN chmod +x /entrypoint.sh
CMD [ "/entrypoint.sh" ]