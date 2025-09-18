#!/bin/bash
set -e

# arguments parsing
if [[ "$#" -eq 0 ]]; then
    echo "Usage: $0 [--init] [--generate-cert] [--start-traefik] [--start-all] [--stop-all] [--stop-traefik] [--delete-volumes]" 
    exit 1
fi

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --init) INIT_SERVICES=true ;;
        --generate-cert) GENERATE_CERT=true ;;
        --start-traefik) START_TRAEFIK=true ;;
        --start-all) START_ALL=true ;;
        --stop-all) STOP_ALL=true ;;
        --stop-traefik) STOP_TRAEFIK=true ;;
        --delete-volumes) DELETE_VOLUMES=true ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

docker_volumes="changedetectionio_data gitea_data gitea_db gotify_data kanboard_data kanboard_db kanboard_plugins kanboard_ssl n8n_data n8n_db n8n_files opengist vaultwarden_data vaultwarden_pgsqldata"

init_services() {
    # replace your domain here

    # prompt for domain
    read -rp "Enter your domain (e.g., example.com): " user_domain
    if [[ -z "$user_domain" ]]; then
        echo "Domain is empty. Using default: localhost.localdomain"
        echo "Default Domain: ${user_domain:=localhost.localdomain}"
    fi
    echo "Using Domain: ${user_domain}"

    grep -rl 'localhost.localdomain' | xargs -I{} sed -i "s|localhost.localdomain|${user_domain}|" {}
    
    # Create Docker external volumes
    for volume in ${docker_volumes}; do
        if ! docker volume ls | grep -q "${volume}"; then
            docker volume create "${volume}"
        fi
    done
    
    if docker network ls | grep -q 'traefik_default'; then
        prompt="The 'traefik_default' network already exists. Do you want to remove it and recreate it? (y/n): "
        read -r -p "$prompt" response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            echo "Operation cancelled."
            exit 0
        fi
        echo "Removing existing traefik_default network..."
        docker network rm traefik_default
    fi
    
    # Create Docker networks
    if ! docker network ls | grep -q 'traefik_default'; then
        docker network create traefik_default --subnet 172.30.0.0/24 --gateway 172.30.0.1
    fi
}

generate_self_signed_cert() {
    pushd services/traefik/certs
    bash ./self-signed-certgen.sh
    popd
}

start_traefik() {
    pushd services/traefik
    docker compose up -d
    popd
}


start_all_services() {
    pushd services
    find . -maxdepth 1 -type d ! -name traefik ! -name . -exec bash -c 'cd "$0" && docker compose up -d' {} \;
    popd
}

stop_traefik() {
    pushd services/traefik
    docker compose down
    popd
}

stop_all_services() {
    pushd services
    find . -maxdepth 1 -type d ! -name traefik ! -name . -exec bash -c 'cd "$0" && docker compose down' {} \;
    popd
}

delete_volumes() {
    docker volume rm ${docker_volumes} 

    # Uncomment the line below if you want to remove all unused volumes
    #docker volume prune -f
}

# Execute actions based on parsed arguments
if [ "$INIT_SERVICES" = true ]; then
    init_services
fi
if [ "$GENERATE_CERT" = true ]; then
    generate_self_signed_cert
fi
if [ "$START_TRAEFIK" = true ]; then
    start_traefik
fi
if [ "$START_ALL" = true ]; then
    start_all_services
fi
if [ "$STOP_ALL" = true ]; then
    stop_all_services
fi
if [ "$STOP_TRAEFIK" = true ]; then
    stop_traefik
fi
if [ "$DELETE_VOLUMES" = true ]; then
    prompt="Are you sure you want to delete all Docker volumes? This action cannot be undone. (y/n): "
    read -r -p "$prompt" response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "Operation cancelled."
        exit 0
    fi
    delete_volumes
fi

# End of script
