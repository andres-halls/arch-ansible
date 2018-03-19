FROM xetusoss/naemon:latest

# install dependencies
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get install -y \
    wget \
    make \
    rrdtool \
    librrds-perl \
    librrd-simple-perl \
    g++ \
    php-cli \
    php-gd \
    php-xml \
    libapache2-mod-php

# download and install pnp4nagios
RUN wget -O pnp4nagios.zip https://github.com/lingej/pnp4nagios/archive/master.zip && \
  unzip pnp4nagios.zip && \
  cd pnp4nagios-master && \
  ./configure --with-nagios-user=naemon --with-nagios-group=naemon && \
  make all && \
  make install && \
  make install-webconf && \
  make install-config && \
  make install-init && \
  cd ../ && \
  rm -rf pnp4nagios.zip pnp4nagios-master

# configure pnp4nagios and thruk
RUN mv /etc/httpd/conf.d/pnp4nagios.conf /etc/apache2/conf-available && \
  ln -sf /etc/apache2/conf-available/pnp4nagios.conf /etc/apache2/conf-enabled/pnp4nagios.conf && \
  sed -i "s|\$conf\['nagios_base'\].*=.*\".*\";|\$conf['nagios_base'] = \"/thruk/cgi-bin\";|" /usr/local/pnp4nagios/etc/config_local.php && \
  sed -i 's;RewriteCond\s\+%{REQUEST_URI}\s\+\^/thruk$;RewriteCond %{REQUEST_URI}           ^/(thruk|pnp4nagios);g' /usr/share/thruk/thruk_cookie_auth.include && \
  rm -f /usr/local/pnp4nagios/share/install.php

# set time zone
ARG TIME_ZONE=Etc/UTC
RUN cp "/usr/share/zoneinfo/$TIME_ZONE" /etc/localtime && echo "$TIME_ZONE" > /etc/timezone

ADD run.sh /run.sh
ENTRYPOINT ["/run.sh"]