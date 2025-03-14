FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php \
    php-fpm \
    php-mysql \
    tar

# Définir le répertoire de travail en accord avec le point de montage du volume
WORKDIR /var/www/wordpress

# Copier la configuration PHP-FPM (si nécessaire)
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# Copier et rendre exécutable le script d'installation
COPY ./conf/auto_config.sh /usr/local/bin/auto_config.sh
RUN chmod +x /usr/local/bin/auto_config.sh

RUN mkdir -p /run/php

ENTRYPOINT ["/usr/local/bin/auto_config.sh"]
CMD ["/usr/sbin/php-fpm7.4", "-F"]
