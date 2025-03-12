#!/bin/sh
# Se placer dans le répertoire de travail
cd /var/www/wordpress

# Si un marqueur existe, on ne réinstalle pas
if [ -f .installed ]; then
    echo "Installation déjà effectuée, pas de réinstallation."
else
    echo "Téléchargement et préparation de WordPress..."

    php -r "file_put_contents('/tmp/wordpress.tar.gz', file_get_contents('https://wordpress.org/wordpress-6.5.5.tar.gz', false, stream_context_create(['ssl' => ['verify_peer' => false, 'verify_peer_name' => false]])));"
    
    # Extraire directement dans /var/www/wordpress avec --strip-components=1
    tar -xzf /tmp/wordpress.tar.gz --strip-components=1
    rm -f /tmp/wordpress.tar.gz

    echo "Configuration de wp-config.php..."
    cp wp-config-sample.php wp-config.php

    sed -i "s/database_name_here/${MYSQL_DATABASE}/" wp-config.php
    sed -i "s/username_here/${MYSQL_USER}/" wp-config.php
    sed -i "s/password_here/${MYSQL_PASSWORD}/" wp-config.php
    sed -i "s/localhost/${WORDPRESS_DB_HOST}/" wp-config.php

    SECRET_KEYS=$(php -r "echo file_get_contents('https://api.wordpress.org/secret-key/1.1/salt/', false, stream_context_create(['ssl' => ['verify_peer' => false, 'verify_peer_name' => false]]));")
    awk -v keys="$SECRET_KEYS" '/That'\''s all, stop editing! Happy publishing\./ {print keys; print; next}1' wp-config.php > wp-config.new && mv wp-config.new wp-config.php

    echo "define('WP_HOME', '${WORDPRESS_URL}');" >> wp-config.php
    echo "define('WP_SITEURL', '${WORDPRESS_URL}');" >> wp-config.php

    echo "Ajustement des permissions..."
    chown -R www-data:www-data /var/www/wordpress
    chmod -R 755 /var/www/wordpress

    echo "Attente de la base de données..."
    sleep 5

    echo "Installation de WordPress..."
    php -r "
    define('WP_INSTALLING', true);
    require_once 'wp-load.php';
    require_once 'wp-admin/includes/upgrade.php';
    \$install = wp_install('${WORDPRESS_TITLE}', '${WORDPRESS_ADMIN_USER}', '${WORDPRESS_ADMIN_EMAIL}', true, '', '${WORDPRESS_ADMIN_PASSWORD}');
    if (is_wp_error(\$install)) {
        echo 'Erreur lors de l\\'installation: ' . \$install->get_error_message();
    } else {
        echo 'Installation réussie.';
    }
    \$user_id = wp_create_user('${WORDPRESS_USER}', '${WORDPRESS_USER_PASSWORD}', '${WORDPRESS_USER_EMAIL}');
    if (!is_wp_error(\$user_id)) {
        \$user = new WP_User(\$user_id);
        \$user->set_role('editor');
        echo 'Utilisateur éditeur créé.';
    } else {
        echo 'Erreur lors de la création de l\\'utilisateur éditeur.';
    }
    " 2>/dev/null

    touch .installed
    echo "WordPress est prêt."
fi

exec "$@"
