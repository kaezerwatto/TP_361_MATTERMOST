#!/bin/bash
# ============================================================
# Script de déploiement Mattermost
# Étudiant: AZAB A RANGA FRANCK MIGUEL
# Matricule: 23V2227
# ============================================================

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo ""
echo -e "${CYAN}================================================${NC}"
echo -e "${CYAN}  DÉPLOIEMENT MATTERMOST - 23V2227${NC}"
echo -e "${CYAN}================================================${NC}"
echo ""

# Vérifier Docker
echo -e "${YELLOW}[1/6] Vérification de Docker...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${RED}✗ Docker n'est pas installé${NC}"
    exit 1
fi
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo -e "${RED}✗ Docker Compose n'est pas installé${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Docker est installé${NC}"

# Créer les dossiers
echo -e "${YELLOW}[2/6] Création des dossiers de données...${NC}"
mkdir -p mattermost_app/config
mkdir -p mattermost_app/data
mkdir -p mattermost_app/logs
mkdir -p mattermost_app/plugins
mkdir -p mattermost_app/client-plugins
mkdir -p mattermost_app/postgres

# Permissions pour Mattermost (UID 2000 par défaut)
chown -R 2000:2000 mattermost_app/config 2>/dev/null || sudo chown -R 2000:2000 mattermost_app/config
chown -R 2000:2000 mattermost_app/data 2>/dev/null || sudo chown -R 2000:2000 mattermost_app/data
chown -R 2000:2000 mattermost_app/logs 2>/dev/null || sudo chown -R 2000:2000 mattermost_app/logs
chown -R 2000:2000 mattermost_app/plugins 2>/dev/null || sudo chown -R 2000:2000 mattermost_app/plugins
chown -R 2000:2000 mattermost_app/client-plugins 2>/dev/null || sudo chown -R 2000:2000 mattermost_app/client-plugins

chmod -R 755 mattermost_app
echo -e "${GREEN}✓ Dossiers créés avec les bonnes permissions${NC}"

# Arrêter les anciens conteneurs si existants
echo -e "${YELLOW}[3/6] Nettoyage des anciens conteneurs...${NC}"
docker-compose down 2>/dev/null || true
echo -e "${GREEN}✓ Nettoyage terminé${NC}"

# Démarrer les conteneurs
echo -e "${YELLOW}[4/6] Démarrage des conteneurs...${NC}"
docker-compose up -d
echo -e "${GREEN}✓ Conteneurs démarrés${NC}"

# Attendre que Mattermost soit prêt
echo -e "${YELLOW}[5/6] Attente du démarrage de Mattermost (90s)...${NC}"
sleep 20
for i in {1..14}; do
    if curl -s http://localhost:5990/api/v4/system/ping > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Mattermost est prêt !${NC}"
        break
    fi
    echo "   Attente... ($((i*5))s)"
    sleep 5
done

# Afficher le statut
echo ""
echo -e "${CYAN}================================================${NC}"
echo -e "${GREEN}  DÉPLOIEMENT TERMINÉ !${NC}"
echo -e "${CYAN}================================================${NC}"
echo ""
docker-compose ps
echo ""
echo -e "${GREEN}Mattermost est accessible sur:${NC}"
echo "  - Local: http://localhost:5990"
echo "  - HTTPS: https://23v2227.systeme-res30.app"
echo ""
echo -e "${YELLOW}Configuration Nginx:${NC}"
echo "  sudo cp nginx-23v2227.conf /etc/nginx/sites-available/23v2227_mattermost.conf"
echo "  sudo ln -sf /etc/nginx/sites-available/23v2227_mattermost.conf /etc/nginx/sites-enabled/"
echo "  sudo nginx -t && sudo systemctl reload nginx"
echo ""
echo -e "${CYAN}Première connexion:${NC}"
echo "  1. Ouvrez https://23v2227.systeme-res30.app"
echo "  2. Créez le compte administrateur"
echo "  3. Créez votre première équipe (team)"
echo ""
