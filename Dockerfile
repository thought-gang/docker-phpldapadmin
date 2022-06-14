FROM debian:bookworm-slim

LABEL maintainer Felix Hoßfeld <felix.hossfeld@thoughtgang.de>
LABEL version="0.1"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y apache2 phpldapadmin ca-certificates libldap-common  patch --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# https://httpd.apache.org/docs/2.4/stopping.html#gracefulstop
STOPSIGNAL SIGWINCH

ENV LANG=C
ENV APACHE_PID_FILE=/var/run/apache2/apache2.pid
ENV APACHE_RUN_DIR=/var/run/apache2
ENV APACHE_LOCK_DIR=/var/lock/apache2
ENV APACHE_LOG_DIR=/var/log/apache2

ENV APACHE_RUN_USER=www-data
ENV APACHE_RUN_GROUP=www-data

ENV PLA_HOST=127.0.0.1
ENV PLA_PORT=389
ENV PLA_TLS=false
ENV PLA_BASE=
ENV PLA_ADMIN=cn=admin,dc=example,dc=com
ENV PLA_UNIQUE_ATTRS='mail uid uidNumber'

COPY config.php.diff php8_compatibility.diff /usr/share/phpldapadmin

RUN install  -d -m 0700 -o  ${APACHE_RUN_USER} -g ${APACHE_RUN_USER} ${APACHE_RUN_DIR} && \
    a2disconf other-vhosts-access-log && \
    rm /etc/apache2/sites-enabled/000-default.conf && \
    sed -i 's/^ErrorLog .*$/ErrorLog \/dev\/stderr/' /etc/apache2/apache2.conf && \
    sed -i 's/Alias \/phpldapadmin \/usr\/share\/phpldapadmin\/htdocs/Alias \/ \/usr\/share\/phpldapadmin\/htdocs\//' /etc/phpldapadmin/apache.conf  && \
    patch -p 1 -d /etc/phpldapadmin < /usr/share/phpldapadmin/config.php.diff && \
    patch -p 1 -d  /usr/share/phpldapadmin < /usr/share/phpldapadmin/php8_compatibility.diff && \
    rm  /usr/share/phpldapadmin/config.php.diff /usr/share/phpldapadmin/php8_compatibility.diff 

USER ${APACHE_RUN_USER}:${APACHE_RUN_USER}

EXPOSE 80

ENTRYPOINT [ "/usr/sbin/apache2",  "-DFOREGROUND" ]
