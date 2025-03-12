#run execute pendant le docker build, cmd s'execute quand le conteneur demarre

# Utiliser l'image de base Debian 11
FROM debian:bullseye

# Mettre à jour et installer les paquets nécessaires
RUN apt update && apt install -y nginx openssl 

# Créer les répertoires nécessaires pour fichier PID, sockets UNIX de nginx creer le repertoire et ajouter un fichier index.html, Créer les répertoires pour les certificats SSL
RUN mkdir -p /run/nginx /var/www/html /etc/ssl/certs /etc/ssl/private /etc/nginx/ssl

# S'assurer que nous avons les droits nécessaires sur /var/www/html
RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

# Copier les fichiers de configuration NGINX
COPY conf/nginx.conf /etc/nginx/conf.d


# Copier le script de setup pour générer le certificat SSL auto-signé et configurer Nginx
COPY tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

# Exposer le port HTTPS
EXPOSE 443

# Lancer le script de setup
ENTRYPOINT ["/usr/local/bin/setup.sh"]

# Demarrer NGINX en mode foreground
CMD ["nginx", "-g", "daemon off;"]