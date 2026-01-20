function cleanDocker
  if gum confirm "Are you sure you want to clean all Docker data? This will remove all containers, images, volumes, and networks." --default=no
    # Stoppe tous les conteneurs
    docker stop $(docker ps -aq)

    # Supprime tous les conteneurs
    docker rm $(docker ps -aq)

    # Supprime toutes les images
    docker rmi -f $(docker images -aq)

    # Supprime tous les volumes
    docker volume rm $(docker volume ls -q)

    # Supprime tous les réseaux inutilisés
    docker network prune -f
  else
    echo "Operation cancelled."
    return 1
  end
end
