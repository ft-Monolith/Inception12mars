# FROM debian:bullseye

# # 1) Installe wget + dépendances PHP
# RUN apt-get update && apt-get -y install wget

# RUN apt-get update && apt-get install -y \
#     php \
#     php-fpm \
#     php-mysql 
#     #ne pas installer mariadb ici masi passer par php

# # 2) Copier la config PHP-FPM (version 7.4)
# COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf


# #REMPLACER wget curl wp-cli
# # 3) Télécharger WordPress dans /var/www
# RUN wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz -P /var/www

# # 4) Décompresser et supprimer l’archive
# RUN cd /var/www && tar -xzf wordpress-6.0-fr_FR.tar.gz && rm wordpress-6.0-fr_FR.tar.gz

# # 5) Donner les droits à root (puisque tu utilises --allow-root avec WP-CLI)
# RUN chown -R root:root /var/www/wordpress

# # 6) Installer WP-CLI version 2.7.1 (pour éviter le bug de la 2.8.x)
# RUN apt-get update && apt-get install -y curl \
#  && curl -L https://github.com/wp-cli/wp-cli/releases/download/v2.7.1/wp-cli-2.7.1.phar \
#     -o /usr/local/bin/wp \
#  && chmod +x /usr/local/bin/wp

# # 7) Copier et rendre exécutable le script auto_config.sh
# COPY ./conf/auto_config.sh /usr/local/bin/auto_config.sh
# RUN chmod +x /usr/local/bin/auto_config.sh

# # 8) Lancer auto_config.sh au démarrage
# ENTRYPOINT ["/usr/local/bin/auto_config.sh"]

# # 9) Créer /run/php (pour php-fpm)
# RUN mkdir -p /run/php

# # 10) Démarrer PHP-FPM
# CMD ["/usr/sbin/php-fpm7.4", "-F"]

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
