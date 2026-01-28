# Mattermost - TP INF3611 Administration Systèmes

## 1. Informations Étudiant et URL (1 pt)

| Information | Valeur |
|-------------|--------|
| **Nom complet** | AZAB A RANGA FRANCK MIGUEL |
| **Matricule** | 23V2227 |
| **URL de l'application** | https://23v2227.systeme-res30.app |
| **Cours** | INF3611 - Administration Systèmes |
| **Université** | Université de Yaoundé I |

---

## 2. Description de l'Application et Instructions de Démarrage (2 pts)

### Description

**Mattermost** est une plateforme de messagerie collaborative open-source et auto-hébergée. Elle permet la communication en temps réel via des canaux (publics/privés), des messages directs, et le partage de fichiers. C'est une alternative sécurisée à Slack, Microsoft Teams ou Discord pour les entreprises.

### Instructions de Démarrage (Local)

```bash
# 1. Cloner le repository
git clone https://github.com/kaezerwatto/TP_361_MATTERMOST.git
cd TP_361_MATTERMOST

# 2. Copier le fichier d'exemple d'environnement
cp .env.example .env

# 3. Éditer le fichier .env avec vos propres valeurs
nano .env

# 4. Créer les répertoires de données
mkdir -p mattermost_app/{config,data,logs,plugins,client-plugins,postgres}

# 5. Lancer l'application
docker compose up -d

# 6. Vérifier que les conteneurs sont en cours d'exécution
docker compose ps

# 7. Accéder à l'application
# Ouvrir https://23v2227.systeme-res30.app dans un navigateur
```

### Étapes de Déploiement Complet sur VPS

#### Étape 1 : Connexion au VPS
```bash
ssh root@vmi2924532.contaboserver.net
# Ou avec l'IP : ssh root@37.60.250.220
```

#### Étape 2 : Installation des prérequis
```bash
# Mise à jour du système
sudo apt update && sudo apt upgrade -y

# Installation de Docker
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER

# Installation de Docker Compose
sudo apt install docker-compose-plugin -y

# Installation de Nginx
sudo apt install nginx -y

# Installation de Certbot
sudo apt install certbot python3-certbot-nginx -y
```

#### Étape 3 : Clonage et configuration du projet
```bash
# Créer le répertoire de travail
mkdir -p /opt/mattermost && cd /opt/mattermost

# Cloner le repository
git clone https://github.com/kaezerwatto/TP_361_MATTERMOST.git .

# Copier et configurer les variables d'environnement
cp .env.example .env
nano .env  # Modifier les valeurs selon vos besoins

# Créer les répertoires de persistance
mkdir -p mattermost_app/{config,data,logs,plugins,client-plugins,postgres}

# Définir les permissions
sudo chown -R 2000:2000 mattermost_app/
```

#### Étape 4 : Lancement des conteneurs Docker
```bash
# Démarrer l'application
docker compose up -d

# Vérifier le statut
docker compose ps

# Consulter les logs si nécessaire
docker compose logs -f mattermost
```

#### Étape 5 : Configuration de Nginx
```bash
# Copier le fichier de configuration vhost
sudo cp 23v2227.conf /etc/nginx/sites-available/23v2227.conf

# Créer le lien symbolique
sudo ln -s /etc/nginx/sites-available/23v2227.conf /etc/nginx/sites-enabled/

# Tester la configuration Nginx
sudo nginx -t

# Recharger Nginx
sudo systemctl reload nginx
```

#### Étape 6 : Génération du certificat SSL
```bash
# Générer le certificat Let's Encrypt
sudo certbot certonly --nginx -d 23v2227.systeme-res30.app

# Recharger Nginx avec le certificat
sudo systemctl reload nginx
```

#### Étape 7 : Vérification finale
```bash
# Tester l'accès HTTPS
curl -I https://23v2227.systeme-res30.app

# Vérifier le certificat SSL
echo | openssl s_client -connect 23v2227.systeme-res30.app:443 2>/dev/null | openssl x509 -noout -dates
```

#### Commandes de gestion utiles
```bash
# Arrêter l'application
docker compose down

# Redémarrer l'application
docker compose restart

# Voir les logs en temps réel
docker compose logs -f

# Mettre à jour Mattermost
docker compose pull && docker compose up -d

# Sauvegarder la base de données
docker exec mattermost_db_23V2227 pg_dump -U mmuser mattermost > backup.sql
```

---

## 3. Rôle de Chaque Service Docker Compose (1 pt)

Le fichier `docker-compose.yml` définit **2 services** :

| Service | Image | Rôle |
|---------|-------|------|
| **mattermost** | `mattermost/mattermost-team-edition:latest` | Serveur principal de l'application Mattermost. Il gère l'interface web, l'API REST, les WebSockets pour la messagerie en temps réel, et le traitement des fichiers. |
| **db** | `postgres:15-alpine` | Base de données PostgreSQL qui stocke toutes les données de l'application : utilisateurs, messages, canaux, fichiers uploadés, configurations. |

### Dépendances

Le service `mattermost` dépend du service `db` via `depends_on` avec condition `service_healthy`, ce qui garantit que la base de données est prête avant le démarrage de Mattermost.

---

## 4. Rôle de Chaque Variable d'Environnement (2 pts)

Les variables sont définies dans le fichier `.env` :

### Variables de Domaine et URL

| Variable | Exemple | Rôle |
|----------|---------|------|
| `MATTERMOST_DOMAIN` | `23v2227.systeme-res30.app` | Nom de domaine de l'application |
| `MATTERMOST_SITE_URL` | `https://23v2227.systeme-res30.app` | URL complète avec protocole HTTPS |

### Variables de Base de Données PostgreSQL

| Variable | Exemple | Rôle |
|----------|---------|------|
| `POSTGRES_DB` | `mattermost` | Nom de la base de données à créer |
| `POSTGRES_USER` | `mmuser` | Nom d'utilisateur pour la connexion à PostgreSQL |
| `POSTGRES_PASSWORD` | `Secure_P@ss!` | Mot de passe de l'utilisateur PostgreSQL |
| `MM_SQLSETTINGS_DATASOURCE` | `postgres://mmuser:...@db:5432/mattermost` | Chaîne de connexion complète à la base de données |

### Variables de Configuration Mattermost

| Variable | Exemple | Rôle |
|----------|---------|------|
| `MATTERMOST_HTTP_PORT` | `5990` | Port HTTP exposé par Docker (mappé vers 8065 interne) |
| `MATTERMOST_WEBSOCKET_PORT` | `5995` | Port pour les connexions WebSocket |

### Variables SMTP (Email)

| Variable | Exemple | Rôle |
|----------|---------|------|
| `MM_EMAIL_SMTP_SERVER` | `smtp.gmail.com` | Serveur SMTP pour l'envoi d'emails |
| `MM_EMAIL_SMTP_PORT` | `587` | Port du serveur SMTP (TLS) |
| `MM_EMAIL_SMTP_USERNAME` | `user@gmail.com` | Identifiant SMTP |
| `MM_EMAIL_SMTP_PASSWORD` | `app_password` | Mot de passe application SMTP |
| `MM_EMAIL_ENABLE_SMTP_AUTH` | `true` | Active l'authentification SMTP |
| `MM_EMAIL_FEEDBACK_EMAIL` | `noreply@domain.app` | Adresse expéditeur des emails |

### Variables Système

| Variable | Exemple | Rôle |
|----------|---------|------|
| `TZ` | `Africa/Douala` | Fuseau horaire du conteneur |

---

## 5. Cas d'Usage en Entreprise (3 pts)

### 📌 Cas d'usage principal : Communication sécurisée d'équipe

Mattermost est idéal pour les entreprises qui nécessitent :

1. **Souveraineté des données** : Contrairement à Slack ou Teams, les données restent sur les serveurs de l'entreprise. Aucune dépendance à un cloud tiers américain.

2. **Conformité réglementaire** : Compatible RGPD (Europe), HIPAA (santé USA), ISO 27001. Essentiel pour les banques, hôpitaux, administrations.

3. **Collaboration temps réel** :
   - Canaux par projet ou département
   - Messages directs et appels
   - Partage de fichiers jusqu'à 100 Mo
   - Historique de recherche complet

4. **Intégration DevOps** :
   - Webhooks vers GitLab, GitHub, Jenkins
   - Notifications automatiques de builds/déploiements
   - ChatOps avec slash commands

### Exemple concret

> **Scénario** : Une PME camerounaise de développement logiciel veut remplacer WhatsApp pour sa communication interne.
>
> **Solution Mattermost** :
> - Canaux `#general`, `#dev`, `#marketing`, `#projets-clients`
> - Intégration GitLab pour notifier les commits
> - Données hébergées localement (conformité MINPOSTEL)
> - Coût : Gratuit (Team Edition) vs 7$/utilisateur/mois pour Slack

---

## 6. Rôle de Let's Encrypt et Certbot (1 pt)

### Let's Encrypt

**Let's Encrypt** est une autorité de certification (CA) gratuite et automatisée. Elle délivre des certificats TLS/SSL reconnus par tous les navigateurs, permettant le chiffrement HTTPS.

### Certbot

**Certbot** est l'outil officiel client de Let's Encrypt. Il automatise :
- La génération de la demande de certificat (CSR)
- La validation du domaine (challenge HTTP ou DNS)
- L'installation du certificat
- Le renouvellement automatique (certificats valides 90 jours)

### Pourquoi c'est important ?

| Sans certificat | Avec certificat |
|-----------------|-----------------|
| `http://` (non sécurisé) | `https://` (chiffré) |
| Données en clair | Données chiffrées TLS 1.3 |
| Avertissement navigateur | Cadenas vert  |
| Vulnérable au MITM | Protection contre interception |

---

## 7. Contenu du Fichier de Configuration Nginx (2 pts)

Le fichier `23v2227.conf` configure Nginx comme reverse proxy pour Mattermost :

```nginx
# Upstream - Pool de connexion vers Mattermost
upstream mattermost_backend {
    server 127.0.0.1:5990;
    keepalive 32;
}

# Bloc HTTP - Redirection vers HTTPS
server {
    listen 80;
    listen [::]:80;
    server_name 23v2227.systeme-res30.app;
    return 301 https://$server_name$request_uri;
}

# Bloc HTTPS - Configuration SSL et Proxy
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name 23v2227.systeme-res30.app;

    # Certificats SSL (générés par Certbot)
    ssl_certificate /etc/letsencrypt/live/23v2227.systeme-res30.app/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/23v2227.systeme-res30.app/privkey.pem;
    
    # Protocoles et chiffrement sécurisés
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256;
    ssl_prefer_server_ciphers off;

    # Headers de sécurité
    add_header Strict-Transport-Security "max-age=31536000" always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;

    # Taille maximale des uploads
    client_max_body_size 100M;

    # Proxy vers Mattermost
    location / {
        proxy_pass http://mattermost_backend;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Support WebSocket (essentiel pour Mattermost)
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }

    # Logs
    access_log /var/log/nginx/23v2227_mattermost_access.log;
    error_log /var/log/nginx/23v2227_mattermost_error.log;
}
```

### Points clés de la configuration

| Élément | Rôle |
|---------|------|
| `upstream` | Définit le pool de connexion vers le port 5990 |
| Port 80 → 443 | Redirige tout le trafic HTTP vers HTTPS |
| `ssl_certificate` | Chemin vers le certificat Let's Encrypt |
| `ssl_protocols TLSv1.2 TLSv1.3` | Désactive les protocoles obsolètes |
| `proxy_set_header Upgrade` | Active le support WebSocket |
| `client_max_body_size 100M` | Autorise les uploads jusqu'à 100 Mo |

---

## 8. Étapes de Génération du Certificat TLS avec Certbot (3 pts)

### Prérequis

- Nginx installé et configuré
- Le domaine `23v2227.systeme-res30.app` doit pointer vers le VPS (DNS A record)
- Port 80 ouvert pour le challenge HTTP

### Commande de génération

```bash
# Générer le certificat pour le domaine spécifique
sudo certbot certonly --nginx -d 23v2227.systeme-res30.app
```

### Étapes détaillées

1. **Installation de Certbot** (si nécessaire) :
```bash
sudo apt update
sudo apt install certbot python3-certbot-nginx -y
```

2. **Vérification que Nginx est en cours d'exécution** :
```bash
sudo systemctl status nginx
```

3. **Exécution de Certbot** :
```bash
sudo certbot certonly --nginx -d 23v2227.systeme-res30.app
```

4. **Interaction avec Certbot** :
   - Entrer une adresse email (pour les notifications d'expiration)
   - Accepter les conditions d'utilisation (A)
   - Optionnel : partager l'email avec EFF (N)
   - Certbot valide automatiquement le domaine via Nginx

5. **Redémarrer Nginx** :
```bash
sudo systemctl reload nginx
```

### Emplacement des certificats générés

Les certificats sont stockés dans `/etc/letsencrypt/live/23v2227.systeme-res30.app/` :

| Fichier | Description |
|---------|-------------|
| `fullchain.pem` | Certificat complet (certificat + chaîne intermédiaire) |
| `privkey.pem` | Clé privée du certificat |
| `cert.pem` | Certificat du domaine uniquement |
| `chain.pem` | Chaîne de certification intermédiaire |

### Structure du répertoire

```
/etc/letsencrypt/
├── live/
│   └── 23v2227.systeme-res30.app/
│       ├── fullchain.pem   ← Utilisé dans nginx (ssl_certificate)
│       ├── privkey.pem     ← Utilisé dans nginx (ssl_certificate_key)
│       ├── cert.pem
│       └── chain.pem
├── archive/                 ← Versions historiques des certificats
└── renewal/                 ← Configuration de renouvellement automatique
    └── 23v2227.systeme-res30.app.conf
```

### Renouvellement automatique

Les certificats Let's Encrypt expirent après **90 jours**. Certbot configure automatiquement un cron job ou timer systemd pour le renouvellement :

```bash
# Vérifier le timer de renouvellement
sudo systemctl status certbot.timer

# Tester le renouvellement (dry-run)
sudo certbot renew --dry-run

# Forcer le renouvellement manuel si nécessaire
sudo certbot renew
```

---

## 📁 Structure du Projet

```
23V2227_mattermost/
├── docker-compose.yml      # Configuration des services Docker
├── .env                    # Variables d'environnement (NON versionné)
├── .env.example            # Template pour .env
├── 23v2227.conf            # Configuration Nginx vhost
├── deploy.sh               # Script de déploiement automatisé
├── README.md               # Cette documentation
└── mattermost_app/         # Volumes bind pour la persistance
    ├── config/             # Configuration Mattermost
    ├── data/               # Fichiers uploadés
    ├── logs/               # Journaux applicatifs
    ├── plugins/            # Plugins Mattermost
    ├── client-plugins/     # Plugins côté client
    └── postgres/           # Données PostgreSQL
```

---

##  Résumé des Points d'Évaluation

| Critère | Points | Statut |
|---------|--------|--------|
| Application accessible via HTTPS | 10 |  |
| Respect des ports | 2 |  Port 5990 |
| Variables d'environnement dans .env | 4 |  |
| Volumes bind (app + DB) | 6 |  `./mattermost_app/` |
| Réseau avec nomenclature | 3 |  `mattermost_network` |
| Infos étudiant + URL | 1 |  Section 1 |
| Description + démarrage | 2 |  Section 2 |
| Rôle des services | 1 |  Section 3 |
| Rôle des variables env | 2 |  Section 4 |
| Cas d'usage entreprise | 3 |  Section 5 |
| Rôle Let's Encrypt/Certbot | 1 |  Section 6 |
| Contenu config Nginx | 2 |  Section 7 |
| Étapes certificat + répertoire | 3 |  Section 8 |
| **TOTAL** | **40** |  |

---

## 📞 Contact

**AZAB A RANGA FRANCK MIGUEL**  
Matricule : 23V2227  
Email : miguel.azab@facsciences-uy1.cm  
GitHub : https://github.com/kaezerwatto/TP_361_MATTERMOST
