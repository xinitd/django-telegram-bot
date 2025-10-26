#!/bin/bash

set -e

echo "Step 1: Checking prerequisites..."

if [ "$EUID" -ne 0 ]; then
  echo "Error: Please run this script with sudo."
  exit 1
fi

check_command() {
  if ! command -v "$1" &> /dev/null; then
    echo "Error: Command '$1' is not installed. Please install it first."
    exit 1
  fi
}

check_command "docker"
check_command "certbot"

if command -v docker-compose &> /dev/null; then
    COMPOSE_CMD="docker-compose"
elif docker compose version &> /dev/null; then
    COMPOSE_CMD="docker compose"
else
    echo "Error: docker-compose or 'docker compose' plugin is not installed."
    exit 1
fi

echo "Prerequisites are met. Using '$COMPOSE_CMD'."

echo "Step 2: Loading configuration..."

if [ ! -f .env ]; then
  echo "Error: .env file not found. Please create it from .env.template and fill it out."
  exit 1
fi

export $(grep -v '^#' .env | xargs)
if [ -z "$DOMAIN_NAME" ] || [ -z "$ADMIN_EMAIL" ]; then
  echo "Error: DOMAIN_NAME or ADMIN_EMAIL is not set in your .env file."
  exit 1
fi

echo "Configuration loaded."

echo "Step 3: Obtaining SSL certificate for $DOMAIN_NAME..."

echo "Stopping existing containers to free up port 80..."

$COMPOSE_CMD down &> /dev/null || true

certbot certonly --standalone -d $DOMAIN_NAME --email $ADMIN_EMAIL --agree-tos --non-interactive

echo "SSL certificate obtained."

echo "Step 4: Copying certificates and setting permissions..."

CERT_PATH="./nginx/certs/live/$DOMAIN_NAME"
mkdir -p "$CERT_PATH"

cp "/etc/letsencrypt/live/$DOMAIN_NAME/fullchain.pem" "$CERT_PATH/"
cp "/etc/letsencrypt/live/$DOMAIN_NAME/privkey.pem" "$CERT_PATH/"

chown -R "$SUDO_USER:$SUDO_USER" ./nginx

echo "Certificates are ready."

echo "Step 5: Launching application with Docker Compose..."

$COMPOSE_CMD up -d --build

echo "----------------------------------------------------"
echo "Success! Your application is up and running."
echo "----------------------------------------------------"
