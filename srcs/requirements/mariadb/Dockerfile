
FROM debian:bullseye

# Installer les dépendances nécessaires, EST-CE QUE JE DOIS INSTALLER MARIADB AUTREMENT?
RUN apt-get update && apt-get upgrade -y && apt-get install -y mariadb-server

# Créer les répertoires nécessaires pour MariaDB avec des permissions correctes
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld && chmod 755 /run/mysqld

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

EXPOSE 3306

# Lancer setup.sh avant de démarrer MariaDB
ENTRYPOINT ["/setup.sh"]

