#!/bin/bash

echo "🚀 Initialisation de MariaDB..."

# Démarrer MariaDB en mode sécurisé (daemon) &interdit c arriere plan
mysqld_safe --bind-address=0.0.0.0

# Attendre que MariaDB soit totalement opérationnel
echo "⏳ Attente du démarrage de MariaDB..."
while ! mysqladmin ping -h localhost --silent; do
    sleep 2
done

echo "✅ MariaDB est en ligne, création de la base de données et des utilisateurs..."

# Créer la base de données si elle n'existe pas
mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"

# Créer un utilisateur et lui accorder des privilèges
mysql -u root -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -u root -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"
mysql -u root -e "FLUSH PRIVILEGES;"

# Modifier le mot de passe root
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
mysql -u root -e "FLUSH PRIVILEGES;"

echo "✅ Configuration terminée. Lancement de MariaDB en mode normal..."

# 4) Éteindre proprement le process de config
mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
# **Pas de `shutdown`, car ça tuerait le conteneur**
# Lancer MariaDB en mode daemon pour éviter que le conteneur ne s'arrête ATTENTION PAS LE DROIT A WAIT
# wait
echo "Configuration terminée !"

# 5) Relancer MariaDB *au premier plan* => plus de background (&), ni de wait
exec mysqld_safe --bind-address=0.0.0.0
