#!/bin/sh

# Generer un certificat auto-signe valide 365j, avec une cle privee rsa:2048 -x509 est un format de certification ssl pour https
#keyout enregistre la cles privee
#-out enregistre le certificat ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=$CERT_COUNTRY/ST=$CERT_STATE/L=$CERT_LOCALITY/O=$CERT_ORG/OU=$CERT_ORG_UNIT/CN=$CERT_COMMON_NAME"

# Copier un fichier HTML de test
# echo "<h1>Bienvenue sur Inception</h1>" > /var/www/html/index.html

# Demarrer NGINX en mode foreground
nginx -g "daemon off;"
#faire docker-compose up --build -d pour mettre en background