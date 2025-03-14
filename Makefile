.PHONY: all stop clean re prepare

# Exécute tout : prépare les volumes et démarre les containers
all: prepare
	docker-compose -f srcs/docker-compose.yml up -d --build

# Vérifie et crée les volumes nécessaires AVANT de lancer Docker
prepare:
	mkdir -p /home/qordoux/data/mariadb_data /home/qordoux/data/wordpress_data

# Arrête et supprime les containers sans toucher aux volumes
stop:
	docker-compose -f srcs/docker-compose.yml down

# Nettoie les containers, images, réseaux et fichiers des volumes inutilisés, prune remove orphans
clean: stop
	sudo docker system prune -af --volumes
	sudo docker volume rm $$(docker volume ls -qf dangling=true)
	sudo rm -rf /home/qordoux/data/wordpress_data/*
	sudo rm -rf /home/qordoux/data/mariadb_data/*

# Relance complètement le projet après suppression totale
re: clean all
