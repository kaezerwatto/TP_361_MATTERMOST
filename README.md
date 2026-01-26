# 💬 Mattermost - Plateforme de Messagerie d'Équipe

## 📋 Informations Étudiant

| Champ | Valeur |
|-------|--------|
| **Nom** | AZAB A RANGA FRANCK MIGUEL |
| **Matricule** | 23V2227 |
| **Application** | Mattermost Team Edition |
| **URL** | https://23v2227.systeme-res30.app |
| **Port HTTP** | 5990 (interne) |
| **Port WebSocket** | 5995 (configuré) |
| **Cours** | INF3611 - Administration Systèmes |
| **Université** | Université de Yaoundé I |
| **Date** | 26 janvier 2026 |
| **Deadline** | 27 janvier 2026, 08h00 |

---

## 📖 Description de l'Application

**Mattermost** est une plateforme de messagerie collaborative open-source auto-hébergée, conçue pour remplacer Slack, Microsoft Teams ou Discord en entreprise. Elle offre un contrôle total sur les données, une sécurité renforcée et peut être personnalisée via des plugins.

### 🎯 Caractéristiques principales

- **Open Source** : Code source disponible, personnalisable et auditable
- **Auto-hébergé** : Toutes les données restent sur vos serveurs (souveraineté)
- **Messagerie en temps réel** : Via WebSockets pour la communication instantanée
- **Canaux structurés** : Publics, privés, messages directs et groupes
- **Partage de fichiers** : Upload jusqu'à 100 MB par fichier
- **Recherche avancée** : Recherche full-text dans tout l'historique
- **Intégrations** : Webhooks entrants/sortants, slash commands, plugins
- **API REST complète** : Automatisation et développement d'extensions
- **Mobile & Desktop** : Applications natives iOS, Android, Windows, Mac, Linux
- **Conforme** : RGPD, HIPAA, ISO 27001 compatible

### 💼 Cas d'usage en entreprise

1. **Communication d'équipe sécurisée** 
   - Hébergement sur site pour garantir la confidentialité des échanges sensibles
   - Conformité aux réglementations (RGPD pour l'Europe, HIPAA pour la santé)
   - Chiffrement des données en transit (TLS) et au repos (PostgreSQL)

2. **Intégration DevOps** 
   - Intégration native avec GitLab, GitHub, Jenkins, Prometheus, Grafana
   - Notifications automatiques lors de commits, builds, incidents
   - Automatisation de workflows via ChatOps et slash commands
   - Bots pour CI/CD et monitoring

3. **Collaboration interservices** 
   - Canaux publics pour la transparence organisationnelle
   - Canaux privés pour projets confidentiels
   - Messages directs pour communications 1-on-1
   - Threads pour conversations organisées

4. **Gestion de crise** 
   - Utilisé par des organisations gouvernementales et militaires
   - Déploiement on-premise ou air-gapped (sans Internet)
   - Communication sécurisée lors d'incidents critiques
   - Historique complet pour audits post-incident

5. **Support client interne** 
   - Canaux dédiés par département ou équipe
   - Historique complet avec recherche pour résoudre les problèmes récurrents
   - Intégrations avec systèmes de ticketing (Jira, ServiceNow)
   - Base de connaissances intégrée

6. **Enseignement et formation**
   - Alternative à Discord pour les universités
   - Canaux par cours ou promotion
   - Partage de documents et ressources pédagogiques
   - Préservation de l'historique académique

---

## 🏗️ Architecture Technique

### Infrastructure globale

```
┌─────────────────────────────────────────────────────────────┐
│                  VPS Contabo (vmi2924532)                   │
│          OS: Ubuntu/Debian - IP: vmi2924532.contaboserver.net│
└─────────────────────────────────────────────────────────────┘
                              │
                    ┌─────────┴─────────┐
                    │   Nginx (Host)    │
                    │  Port 80 → 443    │
                    │ SSL Wildcard Cert │
                    └─────────┬─────────┘
                              │
             ┌────────────────┼────────────────┐
             │                                 │
    ┌────────▼─────────┐            ┌────────▼─────────┐
    │   Docker Bridge  │            │   Docker Bridge  │
    │ mattermost_network│           │  autres réseaux  │
    └────────┬─────────┘            └──────────────────┘
             │
    ┌────────┼────────────┐
    │                     │
┌───▼───────────────┐  ┌─▼─────────────────┐
│   Mattermost      │  │   PostgreSQL 15   │
│   Team Edition    │  │   Alpine          │
│   Container       │  │   Container       │
│   Port: 5990      │  │   Port: 5432      │
│   mattermost_23V2227 │  mattermost_db_23V2227
└───────────────────┘  └───────────────────┘
         │                      │
         │                      │
    ┌────▼──────────────────────▼────┐
    │    Bind Volumes (Host)         │
    │  ./mattermost_app/             │
    │   ├── config/                  │
    │   ├── data/                    │
    │   ├── logs/                    │
    │   ├── plugins/                 │
    │   ├── client-plugins/          │
    │   └── postgres/                │
    └────────────────────────────────┘
```

### Flux de communication

1. **Client → Nginx (Port 443/HTTPS)**
   - Le client se connecte via HTTPS au domaine `23v2227.systeme-res30.app`
   - Nginx termine la connexion SSL avec le certificat wildcard

2. **Nginx → Mattermost (Port 5990)**
   - Nginx fait un reverse proxy vers `127.0.0.1:5990`
   - Headers X-Forwarded-* transmis pour préserver l'IP client
   - Upgrade WebSocket pour communication temps réel

3. **Mattermost → PostgreSQL (Port 5432)**
   - Mattermost se connecte à PostgreSQL via le réseau Docker
   - Nom d'hôte: `db` (résolution DNS interne Docker)
   - Connection string: `postgres://mmuser:PASSWORD@db:5432/mattermost`

4. **Mattermost → Volumes**
   - Écriture des fichiers uploadés dans `./mattermost_app/data`
   - Configuration persistée dans `./mattermost_app/config`
   - Logs stockés dans `./mattermost_app/logs`

---

## 🚀 Instructions de Démarrage

### Prérequis système

| Composant | Requis | Installé |
|-----------|--------|----------|
| **Docker** | ≥ 20.10 | ✅ |
| **Docker Compose** | ≥ 2.0 | ✅ |
| **Nginx** | ≥ 1.18 | ✅ (sur host) |
| **Certificat SSL** | Let's Encrypt | ✅ (wildcard) |
| **Ports disponibles** | 5990, 5432 | ✅ |
| **RAM minimum** | 2 GB | ✅ |
| **Espace disque** | 10 GB | ✅ |

### Structure du projet

```
23V2227_mattermost/
├── docker-compose.yml      # Configuration Docker Compose
├── .env                    # Variables d'environnement (⚠️ secret)
├── nginx-23v2227.conf      # Configuration Nginx reverse proxy
├── deploy.sh               # Script de déploiement automatisé
├── README.md               # Documentation (ce fichier)
├── .gitignore              # Fichiers exclus du versioning
└── mattermost_app/         # Données persistantes (bind volumes)
    ├── config/             # Configuration Mattermost
    ├── data/               # Fichiers uploadés, avatars
    ├── logs/               # Logs application
    ├── plugins/            # Plugins serveur installés
    ├── client-plugins/     # Plugins client (JavaScript)
    └── postgres/           # Données PostgreSQL
```

### Méthode 1 : Déploiement automatique (recommandé)

Le script `deploy.sh` automatise toute l'installation :

```bash
# 1. Copier le projet sur le VPS
scp -r 23V2227_mattermost/ kaezer@vmi2924532.contaboserver.net:~/deployment/

# 2. Se connecter au VPS
ssh kaezer@vmi2924532.contaboserver.net

# 3. Aller dans le dossier du projet
cd ~/deployment/23V2227_mattermost

# 4. Rendre le script exécutable
chmod +x deploy.sh

# 5. Exécuter le déploiement
./deploy.sh
```

Le script effectue automatiquement :
- ✅ Vérification de Docker et Docker Compose
- ✅ Création des dossiers bind volumes
- ✅ Configuration des permissions (UID 2000 pour Mattermost)
- ✅ Nettoyage des anciens conteneurs
- ✅ Démarrage des conteneurs
- ✅ Vérification de santé (healthcheck)
- ✅ Affichage des instructions post-installation

### Méthode 2 : Déploiement manuel

Si vous préférez déployer manuellement :

```bash
# 1. Se connecter au VPS
ssh kaezer@vmi2924532.contaboserver.net
cd ~/deployment/23V2227_mattermost

# 2. Créer les dossiers pour les bind volumes
mkdir -p mattermost_app/{config,data,logs,plugins,client-plugins,postgres}

# 3. Ajuster les permissions (UID 2000 = utilisateur Mattermost dans le conteneur)
sudo chown -R 2000:2000 mattermost_app/{config,data,logs,plugins,client-plugins}
chmod -R 755 mattermost_app

# 4. Vérifier le fichier .env
cat .env  # S'assurer que toutes les variables sont définies

# 5. Démarrer les conteneurs
docker-compose up -d

# 6. Vérifier le statut
docker-compose ps
docker logs -f mattermost_23V2227

# 7. Tester l'API (devrait retourner "pong")
curl http://localhost:5990/api/v4/system/ping

# 8. Installer la configuration Nginx
sudo cp nginx-23v2227.conf /etc/nginx/sites-available/23v2227_mattermost.conf
sudo ln -sf /etc/nginx/sites-available/23v2227_mattermost.conf /etc/nginx/sites-enabled/

# 9. Tester et recharger Nginx
sudo nginx -t
sudo systemctl reload nginx

# 10. Vérifier les logs Nginx
sudo tail -f /var/log/nginx/23v2227_mattermost_access.log
```

### Configuration initiale

1. **Accéder à l'interface web**
   - Ouvrir https://23v2227.systeme-res30.app dans un navigateur
   - Le certificat SSL doit être valide (cadenas vert)

2. **Créer le compte administrateur**
   - Le premier utilisateur créé devient automatiquement administrateur système
   - Email: `admin@23v2227.systeme-res30.app`
   - Mot de passe: Suivre les exigences (min 8 caractères, majuscules, chiffres)
   - Nom d'utilisateur: `admin`

3. **Créer une équipe (team)**
   - Cliquer sur "Créer une nouvelle équipe"
   - Nom: Par exemple "INF3611" ou "Équipe 23V2227"
   - URL: `inf3611` → https://23v2227.systeme-res30.app/inf3611

4. **Créer des canaux**
   - **Canaux publics** : Visible par tous les membres de l'équipe
   - **Canaux privés** : Sur invitation uniquement
   - **Messages directs** : Conversations 1-on-1

5. **Inviter des utilisateurs**
   - Menu équipe → Inviter des personnes
   - Par email ou lien d'invitation
   - Définir les rôles (Member, Admin)

---

## 🔧 Explication Détaillée des Services

### Service `mattermost` (Application principale)

**Image** : `mattermost/mattermost-team-edition:latest`
- Version gratuite open-source de Mattermost
- Supporte un nombre illimité d'utilisateurs
- Limitations vs Enterprise : pas de SAML SSO, pas de compliance exports automatiques

**Fonctionnalités** :
- 💬 **Messagerie temps réel** : WebSockets pour communication instantanée
- 📁 **Gestion de fichiers** : Upload, stockage, preview, recherche
- 🔍 **Recherche full-text** : ElasticSearch-like intégré
- 🔔 **Notifications** : Desktop, mobile, email, webhooks
- 🔌 **Plugins** : Système de plugins serveur (Go) et client (JavaScript/React)
- 🤖 **Bots & Intégrations** : Webhooks entrants/sortants, slash commands, OAuth 2.0
- 📊 **API REST v4** : API complète pour automatisation

**Configuration** (variables d'environnement principales) :

| Variable | Valeur | Description |
|----------|--------|-------------|
| `MM_SQLSETTINGS_DRIVERNAME` | `postgres` | Pilote de base de données |
| `MM_SQLSETTINGS_DATASOURCE` | Depuis `.env` | Chaîne de connexion PostgreSQL |
| `MM_SERVICESETTINGS_SITEURL` | https://23v2227.systeme-res30.app | URL publique |
| `MM_SERVICESETTINGS_LISTENADDRESS` | `:8065` | Port d'écoute interne |
| `MM_EMAILSETTINGS_SMTPSERVER` | smtp.gmail.com | Serveur SMTP |
| `MM_EMAILSETTINGS_SMTPPORT` | 587 | Port SMTP (STARTTLS) |
| `MM_FILESETTINGS_MAXFILESIZE` | 104857600 | 100 MB max par fichier |
| `MM_PLUGINSETTINGS_ENABLE` | true | Active les plugins |

**Ports exposés** :
- `5990:8065` - HTTP (API REST + WebSockets)
- Port 5990 sur l'hôte → Port 8065 dans le conteneur

**Healthcheck** :
```bash
curl -f http://localhost:8065/api/v4/system/ping
# Retourne: {"status":"OK"}
```
- Interval: 30s
- Timeout: 10s
- Retries: 5
- Start period: 60s (temps de démarrage)

**Volumes montés** :
```yaml
./mattermost_app/config:/mattermost/config:rw
    → Fichiers config.json, cloud.json
./mattermost_app/data:/mattermost/data:rw
    → Fichiers uploadés organisés par date
./mattermost_app/logs:/mattermost/logs:rw
    → mattermost.log (rotation automatique)
./mattermost_app/plugins:/mattermost/plugins:rw
    → Plugins serveur (.tar.gz)
./mattermost_app/client-plugins:/mattermost/client/plugins:rw
    → Plugins client (JS/React compilé)
```

**Dépendances** :
- `depends_on: db` avec `condition: service_healthy`
- Mattermost ne démarre qu'après PostgreSQL
- Restart policy: `unless-stopped` (redémarre automatiquement sauf arrêt manuel)

---

### Service `db` (PostgreSQL 15)

**Image** : `postgres:15-alpine`
- Version Alpine = image légère (~85 MB vs ~300 MB pour Debian)
- PostgreSQL 15 = dernière version stable avec amélioration des performances

**Rôle** :
- Stocke TOUTES les données de Mattermost :
  - 👤 Utilisateurs, profils, préférences
  - 💬 Messages, éditions, réactions
  - 📁 Métadonnées des fichiers (pas le contenu binaire)
  - 🔑 Sessions, tokens OAuth
  - 🔧 Configuration système
  - 📊 Webhooks, intégrations, plugins config

**Configuration PostgreSQL** :

| Variable | Valeur | Description |
|----------|--------|-------------|
| `POSTGRES_DB` | mattermost | Nom de la base de données |
| `POSTGRES_USER` | mmuser | Utilisateur PostgreSQL |
| `POSTGRES_PASSWORD` | Depuis `.env` | Mot de passe (⚠️ confidentiel) |
| `TZ` | Africa/Douala | Fuseau horaire |

**Performance** :
- PostgreSQL utilise la configuration par défaut d'Alpine
- Pour production : optimiser `shared_buffers`, `effective_cache_size`, `work_mem`
- Connections max : 100 par défaut (Mattermost utilise ~20-30)

**Healthcheck** :
```bash
pg_isready -U mmuser -d mattermost
# Retourne: mattermost:5432 - accepting connections
```
- Interval: 10s
- Timeout: 5s
- Retries: 5

**Volume** :
```yaml
./mattermost_app/postgres:/var/lib/postgresql/data
    → Fichiers de données PostgreSQL (base, WAL, etc.)
```

**Sécurité** :
- ⚠️ Port 5432 NON exposé sur l'hôte (sécurité)
- Accessible uniquement via le réseau Docker interne
- Nom d'hôte: `db` (résolution DNS Docker)

**Backup recommandé** :
```bash
# Dump complet
docker exec mattermost_db_23V2227 pg_dump -U mmuser mattermost > backup.sql

# Dump compressé
docker exec mattermost_db_23V2227 pg_dump -U mmuser mattermost | gzip > backup.sql.gz

# Restauration
docker exec -i mattermost_db_23V2227 psql -U mmuser mattermost < backup.sql
```

---

### Réseau Docker : `mattermost_network`

**Type** : Bridge (user-defined)
- Plus sécurisé que le bridge par défaut
- DNS intégré : résolution automatique des noms de services
- Isolation réseau : ne communique pas avec d'autres projets

**Avantages** :
1. **Résolution DNS** : `mattermost` peut ping `db` par son nom
2. **Isolation** : Pas de communication avec `gitea_network` ou autres
3. **Sécurité** : Firewall Docker automatique entre réseaux
4. **Performance** : Communication inter-conteneurs sans NAT

**Inspection** :
```bash
docker network inspect mattermost_network
# Voir les conteneurs connectés et leurs IPs
```

---

## 🔐 Variables d'Environnement (Fichier `.env`)

Le fichier `.env` contient toutes les configurations sensibles. **⚠️ NE JAMAIS versionner ce fichier.**

### 📡 Configuration Domaine

```env
MATTERMOST_DOMAIN=23v2227.systeme-res30.app
MATTERMOST_SITE_URL=https://23v2227.systeme-res30.app
```
- **MATTERMOST_DOMAIN** : Domaine sans protocole
- **MATTERMOST_SITE_URL** : URL complète utilisée pour les liens dans les emails

### 🗄️ Base de Données PostgreSQL

```env
POSTGRES_DB=mattermost
POSTGRES_USER=mmuser
POSTGRES_PASSWORD=Mattermost_23V2227_SecureDB_P@ss!
POSTGRES_HOST=db
```
- **POSTGRES_HOST** : `db` = nom du service Docker (résolution DNS)
- **Mot de passe** : Complexe, unique, stocké uniquement dans `.env`

### 🔗 Connexion Mattermost → PostgreSQL

```env
MM_SQLSETTINGS_DATASOURCE=postgres://mmuser:Mattermost_23V2227_SecureDB_P@ss!@db:5432/mattermost?sslmode=disable&connect_timeout=10
```
Format : `postgres://user:password@host:port/database?options`
- `sslmode=disable` : SSL non requis (communication interne Docker)
- `connect_timeout=10` : 10 secondes avant timeout

### 🌐 Configuration Ports

```env
MATTERMOST_HTTP_PORT=5990
MATTERMOST_WEBSOCKET_PORT=5995
```
- **5990** : Port HTTP principal (utilisé)
- **5995** : Port WebSocket (configuré mais non séparé dans cette version)

### 👤 Compte Administrateur

```env
MM_ADMIN_USERNAME=admin
MM_ADMIN_PASSWORD=Admin_Mattermost_2026!
MM_ADMIN_EMAIL=admin@23v2227.systeme-res30.app
```
⚠️ Ces variables sont documentatives. Le premier compte créé via l'interface devient admin.

### 📧 Configuration SMTP (Gmail)

```env
MM_EMAIL_SMTP_USERNAME=miguel.azab@facsciences-uy1.cm
MM_EMAIL_SMTP_PASSWORD=ocko uznf thiz xjeg
MM_EMAIL_SMTP_SERVER=smtp.gmail.com
MM_EMAIL_SMTP_PORT=587
MM_EMAIL_ENABLE_SMTP_AUTH=true
MM_EMAIL_FEEDBACK_EMAIL=noreply@23v2227.systeme-res30.app
```

**Configuration Gmail** :
1. Activer l'authentification à 2 facteurs sur le compte Gmail
2. Créer un "Mot de passe d'application" dans les paramètres Google
3. Utiliser ce mot de passe (16 caractères) dans `MM_EMAIL_SMTP_PASSWORD`

**Port 587** : STARTTLS (chiffrement opportuniste)
- Alternative : Port 465 (SSL/TLS direct)

**Utilisation** :
- Notifications par email
- Réinitialisation de mot de passe
- Invitations utilisateurs
- Résumés quotidiens/hebdomadaires

### ⏰ Timezone

```env
TZ=Africa/Douala
```
Fuseau horaire pour les logs et timestamps (GMT+1)

---

## 🔐 Configuration Nginx (Reverse Proxy)

Fichier : `nginx-23v2227.conf`

### Upstream Backend

```nginx
upstream mattermost_backend {
    server 127.0.0.1:5990;
    keepalive 32;
}
```
- **keepalive 32** : Maintient 32 connexions persistantes → réduit latence

### Redirection HTTP → HTTPS

```nginx
server {
    listen 80;
    listen [::]:80;
    server_name 23v2227.systeme-res30.app;
    return 301 https://$server_name$request_uri;
}
```
Toutes les requêtes HTTP sont redirigées en HTTPS (301 = Permanently Moved)

### Configuration SSL/TLS

```nginx
ssl_certificate /etc/letsencrypt/live/systeme-res30.app/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/systeme-res30.app/privkey.pem;
```
- **Certificat wildcard** : `*.systeme-res30.app`
- Couvre tous les sous-domaines (22u2028, 23v2227, etc.)

**Protocoles** : TLSv1.2 et TLSv1.3 uniquement
- TLSv1.0 et TLSv1.1 sont obsolètes et vulnérables

**Ciphers** : ECDHE-ECDSA-AES128-GCM-SHA256, etc.
- Forward Secrecy activé (ECDHE)
- GCM mode (sécurisé et performant)

### Headers de Sécurité

```nginx
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header Referrer-Policy "strict-origin-when-cross-origin" always;
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
```

| Header | Description |
|--------|-------------|
| `X-Frame-Options` | Empêche l'embedding dans une iframe (protection clickjacking) |
| `X-Content-Type-Options` | Force le respect du Content-Type (pas de sniffing MIME) |
| `X-XSS-Protection` | Active le filtre XSS du navigateur |
| `Referrer-Policy` | Contrôle les infos transmises via l'en-tête Referer |
| `HSTS` | Force HTTPS pendant 1 an (incluant sous-domaines) |

### Upload de Fichiers

```nginx
client_max_body_size 100M;
client_body_timeout 300s;
```
- **100 MB** : Correspond à `MM_FILESETTINGS_MAXFILESIZE`
- **300s** : Timeout adapté aux connexions lentes

### Proxy Principal

```nginx
location / {
    proxy_pass http://mattermost_backend;
    proxy_http_version 1.1;
    
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    
    proxy_buffering off;
}
```

**Headers essentiels** :
- `Host` : Préserve le nom de domaine original
- `X-Real-IP` : IP du client (pour logs et sécurité)
- `X-Forwarded-For` : Chaîne complète des proxies
- `X-Forwarded-Proto` : https (Mattermost doit savoir qu'on est en HTTPS)

**WebSocket** :
- `Upgrade` et `Connection` : Permettent l'upgrade HTTP → WebSocket
- Essentiel pour la messagerie temps réel

### WebSocket Spécifique

```nginx
location ~ /api/v[0-9]+/(users/)?websocket$ {
    proxy_pass http://mattermost_backend;
    proxy_http_version 1.1;
    
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    
    proxy_read_timeout 3600s;
    proxy_send_timeout 3600s;
}
```
- **Regex** : Match `/api/v4/websocket` et `/api/v4/users/websocket`
- **Timeouts** : 1 heure (connexions WebSocket longues durées)

### Logs

```nginx
access_log /var/log/nginx/23v2227_mattermost_access.log;
error_log /var/log/nginx/23v2227_mattermost_error.log;
```
Logs séparés par application pour faciliter le debugging

---

## 💾 Persistance des Données (Bind Volumes)

Les données sont persistées via des **bind volumes** montés depuis l'hôte vers les conteneurs.

### Avantages des bind volumes

✅ **Sauvegarde simplifiée** : Données directement accessibles sur le système hôte  
✅ **Portabilité** : Facile à migrer vers un autre serveur (copie de dossier)  
✅ **Inspection** : Possibilité d'examiner les fichiers sans accéder au conteneur  
✅ **Récupération** : En cas de crash du conteneur, les données restent intactes  
✅ **Backup incrémental** : Compatible avec rsync, borgbackup, etc.  
✅ **Performances** : Pas de surcouche driver Docker (accès direct au système de fichiers)  

### Mapping complet des volumes

| Chemin Conteneur | Chemin Hôte | Propriétaire | Description |
|------------------|-------------|--------------|-------------|
| `/mattermost/config` | `./mattermost_app/config` | 2000:2000 | Fichiers de configuration JSON |
| `/mattermost/data` | `./mattermost_app/data` | 2000:2000 | Fichiers uploadés, avatars, emojis personnalisés |
| `/mattermost/logs` | `./mattermost_app/logs` | 2000:2000 | Logs application (mattermost.log) |
| `/mattermost/plugins` | `./mattermost_app/plugins` | 2000:2000 | Plugins serveur installés (.tar.gz) |
| `/mattermost/client/plugins` | `./mattermost_app/client-plugins` | 2000:2000 | Plugins client (JavaScript/React) |
| `/var/lib/postgresql/data` | `./mattermost_app/postgres` | 999:999 | Base de données PostgreSQL |

### Détail des volumes

#### 📂 `config/` - Configuration Mattermost

Contient :
- `config.json` : Configuration principale (généré au premier démarrage)
- `cloud.json` : Configuration cloud (si applicable)

Exemple de modifications courantes dans `config.json` :
```json
{
  "ServiceSettings": {
    "SiteURL": "https://23v2227.systeme-res30.app",
    "ListenAddress": ":8065",
    "EnableLocalMode": true
  },
  "TeamSettings": {
    "MaxUsersPerTeam": 50,
    "EnableTeamCreation": true
  },
  "SqlSettings": {
    "DriverName": "postgres",
    "DataSource": "postgres://mmuser:PASSWORD@db:5432/mattermost"
  }
}
```

#### 📁 `data/` - Fichiers uploadés

Structure :
```
data/
├── YYYYMMDD/           # Dossiers par date
│   ├── teams/
│   │   └── TEAM_ID/
│   │       └── channels/
│   │           └── CHANNEL_ID/
│   │               └── users/
│   │                   └── USER_ID/
│   │                       └── fichier.pdf
├── users/              # Avatars utilisateurs
└── emoji/              # Emojis personnalisés
```

Exemple : Un fichier uploadé le 26 janvier 2026 dans le canal "general" sera stocké dans :
```
./mattermost_app/data/20260126/teams/TEAM_ID/channels/CHANNEL_ID/users/USER_ID/document.pdf
```

#### 📝 `logs/` - Journaux application

Contient :
- `mattermost.log` : Log principal (rotation automatique)
- `mattermost.log.1`, `.2`, etc. : Logs archivés

Format de log :
```
{"level":"info","ts":1706259600,"caller":"app/server.go:123","msg":"Server is starting","version":"9.2.3"}
{"level":"warn","ts":1706259601,"caller":"api4/user.go:456","msg":"Failed login attempt","username":"admin"}
```

Surveillance en temps réel :
```bash
tail -f ./mattermost_app/logs/mattermost.log
```

#### 🔌 `plugins/` - Plugins serveur

Plugins backend écrits en Go, packagés en `.tar.gz`.

Exemples de plugins populaires :
- **GitHub** : Notifications et intégrations GitHub
- **GitLab** : Notifications GitLab
- **Jira** : Création de tickets depuis Mattermost
- **Zoom** : Lancer des meetings Zoom
- **Giphy** : Envoyer des GIFs animés

Installation manuelle :
```bash
# Télécharger un plugin
wget https://github.com/mattermost/mattermost-plugin-github/releases/download/v2.1.4/github-2.1.4.tar.gz

# Copier dans le dossier
cp github-2.1.4.tar.gz ./mattermost_app/plugins/

# Activer via System Console > Plugins
```

#### 🎨 `client-plugins/` - Plugins client

Code JavaScript/React exécuté côté navigateur.

Structure :
```
client-plugins/
└── com.github.plugin/
    ├── main.js
    ├── main.js.map
    └── manifest.json
```

#### 🗄️ `postgres/` - Base de données

Structure PostgreSQL :
```
postgres/
├── base/               # Fichiers de base de données
├── global/             # Métadonnées globales
├── pg_wal/             # Write-Ahead Logs (transactions)
├── pg_stat/            # Statistiques
└── pg_xact/            # Statut des transactions
```

⚠️ **Ne jamais modifier manuellement** ces fichiers sous peine de corruption.

### Permissions et propriétaires

```bash
# UID 2000 = utilisateur "mattermost" dans le conteneur
sudo chown -R 2000:2000 mattermost_app/{config,data,logs,plugins,client-plugins}

# UID 999 = utilisateur "postgres" dans le conteneur
sudo chown -R 999:999 mattermost_app/postgres

# Permissions lecture/écriture/exécution
chmod -R 755 mattermost_app/
```

### Backup et restauration

#### Backup complet

```bash
#!/bin/bash
BACKUP_DIR="/backup/mattermost_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# 1. Backup PostgreSQL
docker exec mattermost_db_23V2227 pg_dump -U mmuser mattermost | gzip > "$BACKUP_DIR/database.sql.gz"

# 2. Backup fichiers
rsync -avz ./mattermost_app/ "$BACKUP_DIR/files/"

# 3. Backup configuration Nginx
cp nginx-23v2227.conf "$BACKUP_DIR/"
cp .env "$BACKUP_DIR/" # ⚠️ Fichier sensible

echo "Backup terminé : $BACKUP_DIR"
```

#### Restauration

```bash
#!/bin/bash
BACKUP_DIR="/backup/mattermost_20260126_140530"

# 1. Arrêter les conteneurs
docker-compose down

# 2. Restaurer les fichiers
rsync -avz "$BACKUP_DIR/files/" ./mattermost_app/

# 3. Démarrer uniquement PostgreSQL
docker-compose up -d db
sleep 10

# 4. Restaurer la base de données
gunzip < "$BACKUP_DIR/database.sql.gz" | docker exec -i mattermost_db_23V2227 psql -U mmuser mattermost

# 5. Démarrer Mattermost
docker-compose up -d mattermost

echo "Restauration terminée"
```

#### Backup automatisé (cron)

```bash
# Éditer crontab
crontab -e

# Backup quotidien à 3h du matin
0 3 * * * /home/kaezer/deployment/23V2227_mattermost/backup.sh

# Nettoyage des backups > 30 jours
0 4 * * * find /backup/mattermost_* -type d -mtime +30 -exec rm -rf {} \;
```

### Migration vers un nouveau serveur

```bash
# Sur l'ancien serveur
docker-compose down
tar czf mattermost_backup.tar.gz mattermost_app/ docker-compose.yml .env nginx-23v2227.conf

# Transférer vers le nouveau serveur
scp mattermost_backup.tar.gz user@new-server:/opt/

# Sur le nouveau serveur
cd /opt
tar xzf mattermost_backup.tar.gz
cd mattermost_app/..
docker-compose up -d
```

---

## 🔒 Sécurité et Bonnes Pratiques

### 🛡️ Sécurité des conteneurs

#### Isolation réseau
- ✅ Réseau Docker user-defined bridge (isolation entre projets)
- ✅ PostgreSQL non exposé sur l'hôte (port 5432 interne uniquement)
- ✅ Communication chiffrée via TLS (Nginx)

#### Secrets et credentials
```bash
# ⚠️ Ne JAMAIS committer le fichier .env
echo ".env" >> .gitignore

# Permissions restrictives sur .env
chmod 600 .env

# Rotation des mots de passe tous les 6 mois
# Utiliser des mots de passe >20 caractères avec symboles
```

#### Updates de sécurité
```bash
# Mettre à jour Mattermost
docker-compose pull
docker-compose up -d

# Vérifier les CVE
docker scout cves mattermost/mattermost-team-edition:latest
```

### 🔐 Configuration Mattermost sécurisée

Via **System Console** (interface admin) :

#### 1. Authentification
- ✅ Activer l'authentification à 2 facteurs (2FA) : `Security > MFA`
- ✅ Politique de mots de passe forts : 
  - Minimum 10 caractères
  - Majuscules + minuscules + chiffres + symboles
  - Expiration tous les 90 jours
- ✅ Limite de tentatives de connexion : 5 tentatives

#### 2. Permissions
```
System Console > Permissions
- Restreindre création d'équipes aux admins
- Restreindre création de canaux publics
- Activer modération des messages
- Désactiver suppression de messages pour users
```

#### 3. Rate Limiting (Anti-DDoS)
```
System Console > Environment > Rate Limiting
- Enable: true
- Per second: 10 requests
- Per minute: 60 requests
- Memory store size: 10000
```

#### 4. Session Management
```
System Console > Environment > Session Lengths
- Idle timeout: 43200 minutes (30 jours)
- Session cache: 10 minutes
- Extend session on activity: true
```

#### 5. File Uploads
```
System Console > Environment > File Storage
- Max file size: 100 MB
- Allowed extensions: pdf, docx, xlsx, png, jpg, gif, mp4
- Scan uploads for malware (plugin requis)
```

### 🔍 Monitoring et Logs

#### Logs Mattermost
```bash
# Suivre les logs en temps réel
docker logs -f --tail 100 mattermost_23V2227

# Rechercher les erreurs
docker logs mattermost_23V2227 2>&1 | grep -i error

# Logs de connexion
docker logs mattermost_23V2227 2>&1 | grep "login"
```

#### Logs Nginx
```bash
# Access logs (toutes les requêtes)
sudo tail -f /var/log/nginx/23v2227_mattermost_access.log

# Error logs (erreurs 4xx, 5xx)
sudo tail -f /var/log/nginx/23v2227_mattermost_error.log

# Analyser le trafic
sudo cat /var/log/nginx/23v2227_mattermost_access.log | awk '{print $1}' | sort | uniq -c | sort -nr | head -20
```

#### Logs PostgreSQL
```bash
# Connexions actives
docker exec mattermost_db_23V2227 psql -U mmuser -d mattermost -c "SELECT count(*) FROM pg_stat_activity;"

# Requêtes lentes
docker exec mattermost_db_23V2227 psql -U mmuser -d mattermost -c "SELECT query, calls, total_time FROM pg_stat_statements ORDER BY total_time DESC LIMIT 10;"
```

#### Healthchecks
```bash
# Vérifier la santé des conteneurs
docker-compose ps

# Healthcheck Mattermost
curl -f http://localhost:5990/api/v4/system/ping
# Réponse: {"AndroidLatestVersion":"","AndroidMinVersion":"","IosLatestVersion":"","IosMinVersion":""}

# Healthcheck PostgreSQL
docker exec mattermost_db_23V2227 pg_isready -U mmuser -d mattermost
```

#### Métriques système
```bash
# Ressources utilisées
docker stats mattermost_23V2227 mattermost_db_23V2227

# Espace disque
du -sh ./mattermost_app/*
# config:     5 MB
# data:       2 GB (selon usage)
# logs:       100 MB
# plugins:    50 MB
# postgres:   500 MB
```

### 🚨 Alertes et notifications

Configuration de monitoring avec Prometheus (optionnel) :
```yaml
# docker-compose.yml - ajouter un service
  prometheus:
    image: prom/prometheus:latest
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "9090:9090"
```

```yaml
# prometheus.yml
scrape_configs:
  - job_name: 'mattermost'
    static_configs:
      - targets: ['mattermost:8067']  # Port métriques Mattermost
```

---

## 🔧 Commandes de Gestion Utiles

### Gestion des conteneurs

```bash
# Démarrer tous les services
docker-compose up -d

# Arrêter tous les services
docker-compose down

# Redémarrer Mattermost seul (sans toucher à PostgreSQL)
docker-compose restart mattermost

# Redémarrer complètement (down + up)
docker-compose down && docker-compose up -d

# Voir les logs en temps réel
docker-compose logs -f

# Voir les logs d'un service spécifique
docker logs -f mattermost_23V2227

# Vérifier le statut des services
docker-compose ps

# Voir les ressources consommées
docker stats mattermost_23V2227 mattermost_db_23V2227
```

### Gestion de Mattermost

```bash
# Accéder au shell du conteneur
docker exec -it mattermost_23V2227 sh

# CLI Mattermost (à l'intérieur du conteneur)
mattermost version
mattermost user list
mattermost team list
mattermost channel list <team_id>

# Créer un utilisateur en ligne de commande
docker exec -it mattermost_23V2227 mattermost user create \
  --email user@example.com \
  --username johndoe \
  --password SecurePass123! \
  --system-admin

# Réinitialiser un mot de passe
docker exec -it mattermost_23V2227 mattermost user resetpassword \
  --email admin@23v2227.systeme-res30.app \
  --password NewPassword2026!

# Rendre un utilisateur admin système
docker exec -it mattermost_23V2227 mattermost roles system_admin <username>

# Lister les équipes
docker exec -it mattermost_23V2227 mattermost team list

# Ajouter un utilisateur à une équipe
docker exec -it mattermost_23V2227 mattermost team add <team_id> <username>
```

### Gestion de PostgreSQL

```bash
# Accéder à la base de données PostgreSQL
docker exec -it mattermost_db_23V2227 psql -U mmuser -d mattermost

# Dans psql :
# \dt              # Lister les tables
# \d+ Users        # Structure de la table Users
# \du              # Lister les utilisateurs PostgreSQL
# \l               # Lister les bases de données
# \q               # Quitter

# Requêtes SQL utiles
docker exec -it mattermost_db_23V2227 psql -U mmuser -d mattermost -c "SELECT COUNT(*) FROM Users;"
docker exec -it mattermost_db_23V2227 psql -U mmuser -d mattermost -c "SELECT COUNT(*) FROM Posts;"
docker exec -it mattermost_db_23V2227 psql -U mmuser -d mattermost -c "SELECT COUNT(*) FROM Channels;"

# Backup de la base de données
docker exec mattermost_db_23V2227 pg_dump -U mmuser mattermost > backup_$(date +%Y%m%d).sql

# Backup compressé
docker exec mattermost_db_23V2227 pg_dump -U mmuser mattermost | gzip > backup_$(date +%Y%m%d).sql.gz

# Restaurer depuis un backup
docker exec -i mattermost_db_23V2227 psql -U mmuser mattermost < backup_20260126.sql

# Analyser la taille de la base
docker exec mattermost_db_23V2227 psql -U mmuser -d mattermost -c "SELECT pg_size_pretty(pg_database_size('mattermost'));"
```

### Maintenance et nettoyage

```bash
# Nettoyer les images Docker inutilisées
docker image prune -a

# Nettoyer les volumes orphelins
docker volume prune

# Nettoyer le système complet
docker system prune -a --volumes

# Vérifier l'espace disque
df -h
du -sh ./mattermost_app/*

# Rotation des logs Nginx
sudo logrotate -f /etc/logrotate.d/nginx

# Nettoyer les anciens logs Mattermost (> 30 jours)
find ./mattermost_app/logs/ -name "*.log.*" -mtime +30 -delete
```

### Mises à jour

```bash
# Mettre à jour vers la dernière version
cd ~/deployment/23V2227_mattermost

# 1. Backup avant mise à jour
./backup.sh  # (ou script manuel)

# 2. Télécharger la nouvelle image
docker-compose pull

# 3. Redémarrer avec la nouvelle version
docker-compose up -d

# 4. Vérifier les logs
docker logs -f mattermost_23V2227

# 5. Tester l'application
curl http://localhost:5990/api/v4/system/ping
```

### Debugging

```bash
# Vérifier la connectivité réseau entre conteneurs
docker exec mattermost_23V2227 ping db

# Tester la connexion PostgreSQL depuis Mattermost
docker exec mattermost_23V2227 sh -c 'apk add postgresql-client && psql "postgres://mmuser:PASSWORD@db:5432/mattermost" -c "SELECT 1;"'

# Vérifier les variables d'environnement
docker exec mattermost_23V2227 env | grep MM_

# Inspecter la configuration réseau
docker network inspect mattermost_network

# Ports en écoute
docker exec mattermost_23V2227 netstat -tuln

# Processus actifs dans le conteneur
docker exec mattermost_23V2227 ps aux
```

---

## 💰 Monétisation de l'Application

### 💼 Modèles de revenus possibles avec Mattermost

#### 1. 🏢 Hébergement SaaS Mattermost
**Concept** : Proposer Mattermost-as-a-Service pour PME/Startups n'ayant pas de compétences DevOps.

**Offres tarifaires** :
- **Starter** : 5€/utilisateur/mois (jusqu'à 25 users)
  - Installation standard
  - Support email sous 48h
  - Backup hebdomadaire
  
- **Business** : 10€/utilisateur/mois (26-100 users)
  - Personnalisation domaine
  - Support prioritaire sous 24h
  - Backup quotidien
  - 10 plugins premium
  
- **Enterprise** : 15€/utilisateur/mois (>100 users)
  - Haute disponibilité (multi-serveurs)
  - Support 24/7
  - SLA 99.9%
  - Intégrations sur mesure

**Revenus potentiels** :
- 50 clients × 20 utilisateurs moyens × 8€/user = **8 000€/mois**
- Soit **96 000€/an**

---

#### 2. 🔧 Support et Maintenance
**Services** :
- Installation et configuration initiale : **500-1500€** (one-time)
- Contrat de maintenance mensuel : **200-800€/mois**
  - Mises à jour de sécurité
  - Monitoring 24/7
  - Intervention en cas d'incident
- Formation administrateurs (2 jours) : **1200€**

**Revenus potentiels** :
- 10 contrats maintenance à 400€/mois = **4 000€/mois**
- 3 installations/mois = **3 000€/mois**
- **Total** : 7 000€/mois = **84 000€/an**

---

#### 3. 🔌 Développement de Plugins Personnalisés
**Exemples de plugins** :
- Intégration ERP propriétaire (SAP, Odoo) : **5 000-15 000€**
- Connexion CRM (Salesforce, HubSpot) : **3 000-8 000€**
- Workflow automatisé RH : **2 000-5 000€**
- Bot intelligence artificielle : **10 000-30 000€**
- Intégration système legacy : **8 000-20 000€**

**Revenus potentiels** :
- 6 plugins/an à 10 000€ moyens = **60 000€/an**

---

#### 4. 📊 Consulting et Migration
**Services proposés** :
- **Audit infrastructure** : 2-5 jours → **2 000-5 000€**
- **Migration Slack → Mattermost** : 
  - <1000 users : **3 000-8 000€**
  - >1000 users : **10 000-30 000€**
- **Migration Teams → Mattermost** : **5 000-15 000€**
- **Audit de sécurité et conformité** (RGPD, ISO 27001) : **4 000-10 000€**
- **Optimisation performances** : **1 500-4 000€**

**Revenus potentiels** :
- 2 migrations/mois à 8 000€ = **16 000€/mois**
- 4 audits/mois à 3 000€ = **12 000€/mois**
- **Total** : 28 000€/mois = **336 000€/an**

---

#### 5. 🏗️ Hébergement On-Premise Managé
**Concept** : Installer Mattermost sur l'infrastructure client mais gérer l'exploitation.

**Offres** :
- **Bronze** : 500€/mois
  - Monitoring business hours (8h-18h)
  - Mises à jour mensuelles
  - Support email
  
- **Silver** : 1 500€/mois
  - Monitoring 24/7
  - Mises à jour hebdomadaires
  - Support email + téléphone
  - Temps de réponse : 4h
  
- **Gold** : 3 500€/mois
  - Monitoring 24/7 avec alerting
  - Mises à jour automatiques
  - Support dédié 24/7
  - SLA 99.95%
  - Temps de réponse : 1h

**Revenus potentiels** :
- 5 clients Bronze = 2 500€/mois
- 8 clients Silver = 12 000€/mois
- 3 clients Gold = 10 500€/mois
- **Total** : 25 000€/mois = **300 000€/an**

---

#### 6. 🎓 Formation et Certification
**Programme de formation** :

**Formation Administrateur Mattermost** (3 jours)
- Jour 1 : Installation, configuration, architecture
- Jour 2 : Sécurité, intégrations, plugins
- Jour 3 : Monitoring, troubleshooting, best practices
- **Prix** : 1 200€/participant (inter-entreprises)
- **Prix** : 3 500€/session (intra-entreprise jusqu'à 10 personnes)

**Formation DevOps avec Mattermost** (2 jours)
- Intégrations CI/CD (GitLab, Jenkins)
- Automatisation avec ChatOps
- Monitoring avec Prometheus/Grafana
- **Prix** : 900€/participant

**Workshop Quick Start** (1 jour)
- Déploiement rapide
- Configuration de base
- Premiers pas
- **Prix** : 500€/participant

**Revenus potentiels** :
- 2 formations admins/mois à 1200€ × 8 participants = **19 200€/mois**
- 1 formation DevOps/mois à 900€ × 6 participants = **5 400€/mois**
- 3 workshops/mois à 500€ × 4 participants = **6 000€/mois**
- **Total** : 30 600€/mois = **367 200€/an**

---

#### 7. 📱 Services Additionnels

**Applications mobiles personnalisées**
- White-label iOS/Android avec votre branding : **15 000-40 000€**

**Intégration IA et Chatbots**
- Bot assistant basé sur GPT : **8 000-25 000€**
- Analyse de sentiment des conversations : **10 000-30 000€**

**Dashboard Analytics**
- Tableau de bord d'utilisation personnalisé : **5 000-15 000€**
- Rapports automatisés : **3 000-8 000€**

**Conformité et Archivage**
- Solution d'archivage légal : **10 000-25 000€**
- Export conformité RGPD : **5 000-12 000€**

**Revenus potentiels** :
- 8 projets/an à 15 000€ moyens = **120 000€/an**

---

### 📊 Récapitulatif des Revenus Potentiels

| Source de Revenus | Mensuel | Annuel |
|-------------------|---------|--------|
| 1. Hébergement SaaS | 8 000€ | 96 000€ |
| 2. Support & Maintenance | 7 000€ | 84 000€ |
| 3. Développement Plugins | ~5 000€ | 60 000€ |
| 4. Consulting & Migration | 28 000€ | 336 000€ |
| 5. Hébergement On-Premise | 25 000€ | 300 000€ |
| 6. Formation & Certification | 30 600€ | 367 200€ |
| 7. Services Additionnels | ~10 000€ | 120 000€ |
| **TOTAL POTENTIEL** | **~113 600€** | **~1 363 200€** |

### 🎯 Stratégie de Lancement (Année 1)

**Phase 1 : Mois 1-3 (Démarrage)**
- Focus : Support & Installation
- Objectif : 5 clients à 500€/mois
- **Revenus** : 2 500€/mois

**Phase 2 : Mois 4-6 (Croissance)**
- Ajout : Hébergement SaaS (10 clients)
- Ajout : Formations (2 sessions/mois)
- **Revenus** : 8 000€/mois

**Phase 3 : Mois 7-9 (Consolidation)**
- Ajout : Développement plugins
- Ajout : Consulting (2 missions/mois)
- **Revenus** : 20 000€/mois

**Phase 4 : Mois 10-12 (Expansion)**
- Ajout : Hébergement On-Premise (3 clients)
- Scaling SaaS (30 clients)
- **Revenus** : 35 000€/mois

### 💡 Avantages Compétitifs

1. **Open Source** : Coût inférieur à Slack/Teams (pas de licence par user)
2. **Souveraineté des données** : Argument clé pour secteurs régulés (santé, finance, gouvernement)
3. **Personnalisation** : Possibilité d'adapter à 100% aux besoins clients
4. **Pas de vendor lock-in** : Les clients gardent le contrôle de leurs données
5. **Conformité RGPD** : Données hébergées en Europe (France, Allemagne)

### 🎯 Marchés Cibles Prioritaires

1. **Secteur Public** : Mairies, ministères, universités
2. **Santé** : Hôpitaux, cliniques (nécessite conformité HIPAA/HDS)
3. **Finance** : Banques, assurances (besoin de sécurité maximale)
4. **Tech & Startups** : Équipes techniques cherchant alternatives open source
5. **Éducation** : Écoles, universités (remplacement Discord/Slack)
6. **ONG** : Organisations internationales (budgets limités, besoins importants)

### 📈 Scalabilité

**Année 1** : 50 000€ (bootstrap, 1-2 personnes)
**Année 2** : 250 000€ (équipe de 5)
**Année 3** : 800 000€ (équipe de 15)
**Année 5** : 2M€+ (structure établie, expansion internationale)

---

## 📝 Fonctionnalités Principales de Mattermost

### 💬 Messagerie et Communication

#### Canaux (Channels)
- **Canaux publics** : Visibles et accessibles à tous les membres de l'équipe
- **Canaux privés** : Sur invitation uniquement, discussions confidentielles
- **Messages directs** : Conversations 1-on-1
- **Messages de groupe** : Jusqu'à 8 personnes en conversation privée
- **Threads** : Réponses organisées en fils de discussion
- **Réactions** : Emojis standard et personnalisés (👍, ❤️, 🎉, etc.)

#### Formatage des Messages
- **Markdown** : Formatage riche (gras, italique, listes, code)
- **Blocs de code** : Avec coloration syntaxique (Python, Java, JS, etc.)
- **Citations** : `> Texte cité`
- **Mentions** : @username, @channel, @all
- **Liens** : Détection automatique avec preview
- **Hashtags** : Organisation par #tags

#### Recherche
- **Recherche full-text** : Dans tous les messages et fichiers
- **Filtres avancés** : Par canal, auteur, date, avec fichiers
- **Opérateurs** : `from:username`, `in:channel`, `before:2026-01-26`
- **Recherche de fichiers** : Par nom ou contenu (PDF, DOCX)

### 📁 Partage de Fichiers

- **Upload** : Drag & drop ou bouton upload
- **Taille max** : 100 MB par fichier (configurable)
- **Formats supportés** : Documents, images, vidéos, audio, archives
- **Preview** : 
  - Images : Affichage inline avec zoom
  - PDF : Visualiseur intégré
  - Vidéos : Lecteur intégré
  - Code : Coloration syntaxique
- **Téléchargement** : Individuel ou batch
- **Liens publics** : Partage de fichiers avec externes (optionnel)

### 🔔 Notifications

#### Desktop
- Notifications native OS (Windows, macOS, Linux)
- Sons personnalisables
- Badge de compteur

#### Mobile
- Push notifications (iOS, Android)
- Notifications groupées
- Quick reply depuis notification

#### Email
- Résumés quotidiens/hebdomadaires
- Notifications de mentions
- Notifications de messages directs

#### Webhooks
- Webhooks entrants : Recevoir des notifications d'apps externes
- Webhooks sortants : Envoyer des événements vers apps externes

### 🔌 Intégrations et Automatisation

#### Slash Commands
Commandes intégrées :
- `/join [channel]` : Rejoindre un canal
- `/leave` : Quitter le canal actuel
- `/invite @user` : Inviter un utilisateur
- `/kick @user` : Expulser un utilisateur
- `/mute` : Couper les notifications d'un canal
- `/code {text}` : Envoyer du code formaté
- `/shrug {text}` : Ajouter ¯\_(ツ)_/¯
- `/giphy [search]` : Envoyer un GIF (avec plugin)

Slash commands personnalisées :
```bash
# Exemple : Déployer une app
/deploy production api-v2

# Exemple : Créer un ticket Jira
/jira create "Bug critique en production"

# Exemple : Vérifier le statut des serveurs
/status all
```

#### Webhooks Entrants
Recevoir des notifications automatiques :
- **GitLab/GitHub** : Commits, PR, issues
- **Jenkins** : Statut des builds
- **Prometheus** : Alertes monitoring
- **Stripe** : Paiements réussis/échoués
- **Zapier** : Automatisations multi-apps

Configuration :
```bash
# System Console > Integrations > Incoming Webhooks
# URL générée : https://23v2227.systeme-res30.app/hooks/xxxxxxxxxxx

# Exemple curl
curl -X POST https://23v2227.systeme-res30.app/hooks/xxxxxxxxx \
  -H 'Content-Type: application/json' \
  -d '{
    "text": "Déploiement réussi en production! 🚀",
    "username": "Deploy Bot",
    "icon_emoji": ":rocket:"
  }'
```

#### Webhooks Sortants
Envoyer des événements Mattermost vers apps externes :
- Trigger : Mot-clé dans un message
- Envoi HTTP POST vers URL configurée
- Use case : Déclencher scripts, bots, automatisations

#### OAuth 2.0
- **SSO** : Single Sign-On avec GitLab, Google, Microsoft
- **Authentification** : Délégation d'authentification
- **API Access** : Applications tierces peuvent accéder via OAuth

#### Plugins Populaires

**Communication** :
- **Zoom** : Lancer des meetings vidéo
- **Jitsi** : Alternative open-source à Zoom
- **Microsoft Calendar** : Synchronisation calendrier

**Développement** :
- **GitHub** : Notifications, subscriptions, rappels PR
- **GitLab** : Idem GitHub
- **Jira** : Création tickets, notifications
- **Jenkins** : Statut builds, déploiements

**Productivité** :
- **Todo** : Gestion de tâches
- **Remind** : Rappels personnels
- **Poll** : Sondages dans les canaux
- **Agenda** : Planning d'équipe

**Fun** :
- **Giphy** : Envoyer des GIFs animés
- **Memes** : Générateur de memes
- **Custom Emoji** : Emojis personnalisés

### 📊 Administration et Gestion

#### System Console
Interface d'administration complète :

**Environment** :
- Configuration serveur (ports, URL)
- Rate limiting
- Session management
- High availability

**Site Configuration** :
- Nom de l'instance
- Description
- Customization (logo, couleurs)

**Authentication** :
- Email/Password
- OAuth 2.0 (GitLab, Google, Office365)
- SAML 2.0 (Enterprise only)
- LDAP/AD (Enterprise only)

**Users & Teams** :
- Gestion utilisateurs
- Gestion équipes
- Rôles et permissions
- Désactivation/Suppression

**Permissions** :
- Création équipes
- Création canaux
- Invitations
- Édition/Suppression messages
- Mentions @all/@channel

**Integrations** :
- Webhooks
- Slash commands
- OAuth apps
- Bot accounts

#### Rôles et Permissions

| Rôle | Description | Permissions |
|------|-------------|-------------|
| **System Admin** | Super admin | Accès System Console, toutes permissions |
| **Team Admin** | Admin d'équipe | Gérer équipe, canaux, membres |
| **Channel Admin** | Admin de canal | Gérer canal, membres |
| **Member** | Membre standard | Écrire, lire, uploader fichiers |
| **Guest** | Invité | Accès limité à canaux spécifiques |

#### Statistiques et Rapports

**System Console > Reporting** :
- Utilisateurs actifs (DAU, MAU)
- Messages envoyés par jour/mois
- Fichiers uploadés
- Canaux créés
- Posts par utilisateur
- Temps de réponse moyen

**Logs disponibles** :
- Connexions/Déconnexions
- Modifications configuration
- Créations/Suppressions
- Erreurs système

### 🎨 Personnalisation

#### Thèmes
- Thèmes clairs/sombres par défaut
- Création de thèmes personnalisés (couleurs)
- Thèmes par équipe ou global

#### Branding
- Logo personnalisé
- Nom de l'instance
- Icône de connexion
- Email templates personnalisés

#### Langues
- Interface multilingue
- 20+ langues supportées (FR, EN, ES, DE, etc.)
- Contribution communautaire pour traductions

### 📱 Applications Mobiles et Desktop

#### Applications Natives

**Mobile** :
- iOS (App Store)
- Android (Google Play)
- Push notifications
- Partage de fichiers
- Appels audio/vidéo (avec plugins)

**Desktop** :
- Windows (64-bit)
- macOS (Intel & Apple Silicon)
- Linux (AppImage, Snap, DEB, RPM)
- Multi-comptes
- Notifications système

#### Progressive Web App (PWA)
- Accessible via navigateur
- Installation comme app
- Mode offline limité

---

## 🆘 Dépannage (Troubleshooting)

### ❌ Mattermost ne démarre pas

**Symptômes** :
- Conteneur `mattermost_23V2227` en état `Exited` ou `Restarting`
- Erreur dans `docker logs`

**Diagnostic** :
```bash
# Vérifier les logs
docker logs mattermost_23V2227

# Vérifier le statut
docker-compose ps
```

**Solutions** :

1. **Erreur de connexion PostgreSQL**
```
Error: Failed to connect to database
```
→ Vérifier que PostgreSQL est démarré et healthy :
```bash
docker-compose ps db
docker logs mattermost_db_23V2227
```
→ Vérifier la chaîne de connexion dans `.env` :
```bash
grep MM_SQLSETTINGS_DATASOURCE .env
# Doit être : postgres://mmuser:PASSWORD@db:5432/mattermost?sslmode=disable&connect_timeout=10
```

2. **Erreur de permissions sur les volumes**
```
Error: Permission denied on /mattermost/config
```
→ Corriger les permissions :
```bash
sudo chown -R 2000:2000 mattermost_app/{config,data,logs,plugins,client-plugins}
chmod -R 755 mattermost_app/
```

3. **Port 5990 déjà utilisé**
```
Error: bind: address already in use
```
→ Vérifier les processus utilisant le port :
```bash
sudo lsof -i :5990
# ou
sudo netstat -tulnp | grep 5990
```
→ Arrêter le processus concurrent ou changer le port dans `.env`

### ❌ Impossible d'accéder à l'interface web

**Symptômes** :
- Page inaccessible https://23v2227.systeme-res30.app
- Erreur 502 Bad Gateway
- Erreur 504 Gateway Timeout

**Diagnostic** :
```bash
# Vérifier que Mattermost répond localement
curl http://localhost:5990/api/v4/system/ping

# Vérifier Nginx
sudo systemctl status nginx
sudo nginx -t

# Vérifier les logs Nginx
sudo tail -f /var/log/nginx/23v2227_mattermost_error.log
```

**Solutions** :

1. **Nginx non démarré**
```bash
sudo systemctl start nginx
sudo systemctl enable nginx
```

2. **Configuration Nginx incorrecte**
```bash
# Tester la config
sudo nginx -t

# Vérifier que le fichier est activé
ls -la /etc/nginx/sites-enabled/23v2227_mattermost.conf

# Recharger Nginx
sudo systemctl reload nginx
```

3. **Certificat SSL invalide/expiré**
```bash
# Vérifier l'expiration
sudo certbot certificates

# Renouveler si nécessaire
sudo certbot renew

# Vérifier que les chemins sont corrects dans nginx
grep ssl_certificate /etc/nginx/sites-available/23v2227_mattermost.conf
```

4. **Firewall bloque le port 443**
```bash
# Vérifier le firewall
sudo ufw status

# Autoriser HTTPS
sudo ufw allow 443/tcp
sudo ufw allow 80/tcp
```

### ❌ WebSockets ne fonctionnent pas

**Symptômes** :
- Messages n'arrivent pas en temps réel
- Obligation de rafraîchir la page pour voir nouveaux messages
- Erreur dans la console navigateur : `WebSocket connection failed`

**Diagnostic** :
```bash
# Dans le navigateur (F12 Console)
# Chercher : WebSocket connection to 'wss://23v2227.systeme-res30.app/...' failed

# Vérifier la config Nginx
grep -A 5 "websocket" /etc/nginx/sites-available/23v2227_mattermost.conf
```

**Solutions** :

1. **Headers WebSocket manquants dans Nginx**
→ Vérifier dans `nginx-23v2227.conf` :
```nginx
proxy_set_header Upgrade $http_upgrade;
proxy_set_header Connection "upgrade";
```

2. **Timeouts trop courts**
→ Augmenter les timeouts dans Nginx :
```nginx
proxy_read_timeout 3600s;
proxy_send_timeout 3600s;
```

3. **Proxy buffering activé**
→ Désactiver dans Nginx :
```nginx
proxy_buffering off;
```

### ❌ Emails non envoyés

**Symptômes** :
- Pas de réception des emails de notification
- Échec de réinitialisation de mot de passe
- Pas d'email d'invitation

**Diagnostic** :
```bash
# Vérifier les logs Mattermost
docker logs mattermost_23V2227 2>&1 | grep -i "email\|smtp"

# Tester SMTP manuellement
docker exec -it mattermost_23V2227 sh
apk add curl
curl -v --ssl smtp://smtp.gmail.com:587
```

**Solutions** :

1. **Identifiants Gmail incorrects**
→ Vérifier dans `.env` :
- Utiliser un **mot de passe d'application** (pas le mot de passe Gmail normal)
- Activer l'authentification à 2 facteurs sur Google
- Générer un mot de passe d'application : https://myaccount.google.com/apppasswords

2. **Port SMTP bloqué**
→ Tester les ports :
```bash
telnet smtp.gmail.com 587
# ou
nc -zv smtp.gmail.com 587
```
→ Si bloqué, essayer le port 465 (SSL/TLS) au lieu de 587 (STARTTLS)

3. **Configuration SMTP incorrecte**
→ Vérifier dans System Console :
```
System Console > Environment > SMTP
- Server: smtp.gmail.com
- Port: 587
- Username: miguel.azab@facsciences-uy1.cm
- Password: [mot de passe application]
- Connection Security: STARTTLS
```

### ❌ Upload de fichiers échoue

**Symptômes** :
- Erreur lors de l'upload : "File too large"
- Upload bloqué à 0%
- Erreur 413 Payload Too Large

**Diagnostic** :
```bash
# Vérifier la limite dans Mattermost
docker exec mattermost_23V2227 grep -i maxfilesize /mattermost/config/config.json

# Vérifier la limite dans Nginx
grep client_max_body_size /etc/nginx/sites-available/23v2227_mattermost.conf
```

**Solutions** :

1. **Limite Nginx trop basse**
→ Dans `nginx-23v2227.conf` :
```nginx
client_max_body_size 100M;  # Doit correspondre à Mattermost
```
→ Recharger Nginx :
```bash
sudo nginx -t && sudo systemctl reload nginx
```

2. **Limite Mattermost trop basse**
→ Dans `.env` ou System Console :
```env
MM_FILESETTINGS_MAXFILESIZE=104857600  # 100 MB
```
→ Redémarrer Mattermost :
```bash
docker-compose restart mattermost
```

3. **Permissions sur ./mattermost_app/data**
```bash
sudo chown -R 2000:2000 mattermost_app/data
chmod -R 755 mattermost_app/data
```

### ❌ PostgreSQL est lent ou crashe

**Symptômes** :
- Requêtes très lentes
- Timeouts de connexion
- Conteneur `mattermost_db_23V2227` redémarre fréquemment

**Diagnostic** :
```bash
# Vérifier les ressources
docker stats mattermost_db_23V2227

# Vérifier les connexions actives
docker exec mattermost_db_23V2227 psql -U mmuser -d mattermost -c "SELECT count(*) FROM pg_stat_activity;"

# Vérifier les requêtes lentes
docker exec mattermost_db_23V2227 psql -U mmuser -d mattermost -c "SELECT query, calls, total_time FROM pg_stat_statements ORDER BY total_time DESC LIMIT 10;" || echo "pg_stat_statements non activé"

# Vérifier la taille de la base
docker exec mattermost_db_23V2227 psql -U mmuser -d mattermost -c "SELECT pg_size_pretty(pg_database_size('mattermost'));"
```

**Solutions** :

1. **Manque de RAM**
→ Allouer plus de mémoire à PostgreSQL (fichier `docker-compose.yml`) :
```yaml
db:
  deploy:
    resources:
      limits:
        memory: 2G
      reservations:
        memory: 512M
```

2. **Base de données non optimisée**
→ Analyser et nettoyer :
```bash
# VACUUM complet (nettoie l'espace)
docker exec mattermost_db_23V2227 psql -U mmuser -d mattermost -c "VACUUM FULL;"

# ANALYZE (met à jour les statistiques)
docker exec mattermost_db_23V2227 psql -U mmuser -d mattermost -c "ANALYZE;"

# Ré-indexation
docker exec mattermost_db_23V2227 psql -U mmuser -d mattermost -c "REINDEX DATABASE mattermost;"
```

3. **Trop de connexions**
→ Augmenter max_connections dans PostgreSQL (nécessite redémarrage)

### ❌ Problèmes de performance générale

**Symptômes** :
- Interface lente
- Messages prennent du temps à s'afficher
- Recherche très lente

**Diagnostic** :
```bash
# Vérifier les ressources système
docker stats

# Vérifier l'espace disque
df -h

# Taille des données Mattermost
du -sh ./mattermost_app/*
```

**Solutions** :

1. **Manque d'espace disque**
```bash
# Nettoyer Docker
docker system prune -a --volumes

# Nettoyer les anciens logs
find ./mattermost_app/logs/ -name "*.log.*" -mtime +30 -delete

# Nettoyer les logs Nginx
sudo find /var/log/nginx/ -name "*.log.*" -mtime +30 -delete
```

2. **Trop de données en cache**
→ Redémarrer Mattermost pour vider les caches :
```bash
docker-compose restart mattermost
```

3. **Base de données volumineuse**
→ Archiver les anciens canaux inactifs
→ Nettoyer les fichiers supprimés :
```bash
# Via System Console > Environment > File Storage
# "Remove Files From Storage" pour les fichiers supprimés
```

### ❌ Problèmes après mise à jour

**Symptômes** :
- Mattermost ne démarre plus après `docker-compose pull`
- Erreurs de migration de base de données
- Fonctionnalités manquantes

**Diagnostic** :
```bash
# Vérifier la version actuelle
docker exec mattermost_23V2227 mattermost version

# Vérifier les logs de migration
docker logs mattermost_23V2227 2>&1 | grep -i "migration\|upgrade"
```

**Solutions** :

1. **Migration de base de données échouée**
→ Restaurer depuis un backup :
```bash
docker-compose down
# Restaurer le backup (voir section Backup)
docker-compose up -d
```

2. **Version incompatible**
→ Downgrade vers version précédente :
```yaml
# Dans docker-compose.yml
services:
  mattermost:
    image: mattermost/mattermost-team-edition:9.2.3  # Version spécifique au lieu de :latest
```

3. **Toujours faire un backup avant mise à jour**
```bash
# Script de mise à jour sécurisée
./backup.sh
docker-compose pull
docker-compose up -d
# Tester l'application
# Si problème : restaurer le backup
```

### 🔧 Commandes de diagnostic utiles

```bash
# Santé globale des conteneurs
docker-compose ps

# Logs complets
docker-compose logs

# Logs Mattermost uniquement
docker logs -f --tail 100 mattermost_23V2227

# Logs PostgreSQL uniquement
docker logs -f --tail 100 mattermost_db_23V2227

# Inspecter un conteneur
docker inspect mattermost_23V2227

# Vérifier le réseau
docker network inspect mattermost_network

# Tester la connectivité entre conteneurs
docker exec mattermost_23V2227 ping db

# Vérifier les variables d'environnement
docker exec mattermost_23V2227 env | grep MM_

# Espace disque des volumes
du -sh ./mattermost_app/*

# Processus dans le conteneur
docker exec mattermost_23V2227 ps aux

# Ports en écoute
docker exec mattermost_23V2227 netstat -tuln

# Test API Mattermost
curl -v http://localhost:5990/api/v4/system/ping

# Test PostgreSQL
docker exec mattermost_db_23V2227 pg_isready -U mmuser -d mattermost
```

### 📞 Support et Ressources

**Documentation officielle** :
- https://docs.mattermost.com/
- https://docs.mattermost.com/install/install-docker.html

**Forum communautaire** :
- https://forum.mattermost.com/

**Issues GitHub** :
- https://github.com/mattermost/mattermost-server/issues

**Security Updates** :
- https://mattermost.com/security-updates/

**Slack/Discord Support** :
- Mattermost Community Server : https://community.mattermost.com/

---

## 📚 Ressources et Documentation

### 📖 Documentation Officielle

| Ressource | URL | Description |
|-----------|-----|-------------|
| **Documentation principale** | https://docs.mattermost.com/ | Guide complet |
| **Installation Docker** | https://docs.mattermost.com/install/install-docker.html | Guide Docker officiel |
| **Administration** | https://docs.mattermost.com/guides/administrator.html | Guide administrateur |
| **API Reference** | https://api.mattermost.com/ | Documentation API REST v4 |
| **Plugin Development** | https://developers.mattermost.com/extend/plugins/ | Développement de plugins |
| **Webhook Guide** | https://developers.mattermost.com/integrate/webhooks/ | Guide webhooks |
| **Security Docs** | https://docs.mattermost.com/deploy/security.html | Bonnes pratiques sécurité |

### 🎓 Tutoriels et Guides

- **Migration Slack → Mattermost** : https://docs.mattermost.com/onboard/migrating-to-mattermost.html
- **Scaling Mattermost** : https://docs.mattermost.com/scale/scaling-for-enterprise.html
- **High Availability Setup** : https://docs.mattermost.com/scale/high-availability-cluster.html
- **Backup & Disaster Recovery** : https://docs.mattermost.com/deploy/backup-disaster-recovery.html

### 🛠️ Outils Utiles

| Outil | Description | URL |
|-------|-------------|-----|
| **Mattermost CLI** | Outil en ligne de commande | Inclus dans conteneur |
| **mmctl** | CLI moderne (alternative) | https://docs.mattermost.com/manage/mmctl-command-line-tool.html |
| **Mattermost Load Test** | Outil de test de charge | https://github.com/mattermost/mattermost-load-test-ng |
| **Bulk Export Tool** | Export massif de données | https://docs.mattermost.com/manage/bulk-export-tool.html |
| **User Provisioning** | Création utilisateurs en masse | https://docs.mattermost.com/onboard/bulk-loading-data.html |

### 🔌 Plugins Populaires

| Plugin | Description | URL |
|--------|-------------|-----|
| **GitHub** | Intégration GitHub complète | https://github.com/mattermost/mattermost-plugin-github |
| **GitLab** | Intégration GitLab | https://github.com/mattermost/mattermost-plugin-gitlab |
| **Jira** | Gestion de tickets Jira | https://github.com/mattermost/mattermost-plugin-jira |
| **Zoom** | Meetings vidéo Zoom | https://github.com/mattermost/mattermost-plugin-zoom |
| **Jitsi** | Visioconférence open source | https://github.com/mattermost/mattermost-plugin-jitsi |
| **Giphy** | GIFs animés | https://github.com/mattermost/mattermost-plugin-giphy |
| **Todo** | Gestion de tâches | https://github.com/mattermost/mattermost-plugin-todo |
| **Microsoft Calendar** | Intégration calendrier | https://github.com/mattermost/mattermost-plugin-mscalendar |
| **Agenda** | Planning d'équipe | https://github.com/mattermost/mattermost-plugin-agenda |

### 👥 Communauté

**Forums et Support** :
- Forum officiel : https://forum.mattermost.com/
- Reddit : https://reddit.com/r/mattermost
- Stack Overflow : Tag `mattermost`

**Code Source** :
- GitHub Server : https://github.com/mattermost/mattermost-server
- GitHub Mobile : https://github.com/mattermost/mattermost-mobile
- GitHub Desktop : https://github.com/mattermost/desktop

**Social Media** :
- Twitter : @mattermost
- LinkedIn : Mattermost
- YouTube : Mattermost Channel

### 📊 Statistiques et Comparaisons

**Mattermost vs Alternatives** :
- vs Slack : https://mattermost.com/mattermost-vs-slack/
- vs Microsoft Teams : https://mattermost.com/mattermost-vs-microsoft-teams/
- vs Discord : https://mattermost.com/mattermost-vs-discord/

**Cas d'usage entreprise** :
- https://mattermost.com/customers/

---

## ✅ Checklist de Déploiement

### Pré-déploiement

- [ ] Docker et Docker Compose installés sur le VPS
- [ ] Domaine configuré (23v2227.systeme-res30.app)
- [ ] Certificat SSL wildcard obtenu
- [ ] Ports 5990 disponibles
- [ ] Accès SSH au VPS configuré
- [ ] Fichier `.env` créé avec toutes les variables
- [ ] Mots de passe sécurisés générés

### Déploiement

- [ ] Projet copié sur le VPS
- [ ] Dossiers bind volumes créés
- [ ] Permissions correctes (UID 2000 pour Mattermost)
- [ ] Conteneurs démarrés avec `docker-compose up -d`
- [ ] Healthchecks réussis (Mattermost + PostgreSQL)
- [ ] Configuration Nginx copiée dans `/etc/nginx/sites-available/`
- [ ] Lien symbolique créé dans `/etc/nginx/sites-enabled/`
- [ ] Configuration Nginx testée avec `nginx -t`
- [ ] Nginx rechargé avec `systemctl reload nginx`

### Post-déploiement

- [ ] Interface accessible en HTTPS
- [ ] Certificat SSL valide (cadenas vert)
- [ ] Compte administrateur créé
- [ ] Première équipe créée
- [ ] Canaux de base créés (General, Random, Support)
- [ ] Configuration SMTP testée (email de bienvenue reçu)
- [ ] Upload de fichiers testé
- [ ] WebSockets fonctionnels (messages temps réel)
- [ ] Notifications desktop testées
- [ ] Recherche testée

### Sécurité

- [ ] 2FA activé pour les administrateurs
- [ ] Politique de mots de passe forte configurée
- [ ] Rate limiting activé
- [ ] Permissions ajustées (création équipes, canaux)
- [ ] Logs activés
- [ ] Backup automatique configuré
- [ ] Monitoring mis en place
- [ ] Alertes configurées

### Documentation

- [ ] README.md complété
- [ ] Identifiants documentés (coffre-fort de mots de passe)
- [ ] Procédures de backup/restauration testées
- [ ] Contacts support documentés
- [ ] Documentation remise à l'équipe

---

## 📅 Informations de Soumission

| Information | Détail |
|-------------|--------|
| **Projet** | INF3611 - Administration Systèmes |
| **Étudiant** | AZAB A RANGA FRANCK MIGUEL |
| **Matricule** | 23V2227 |
| **Application déployée** | Mattermost Team Edition |
| **URL de production** | https://23v2227.systeme-res30.app |
| **Date de création** | 26 janvier 2026 |
| **Date de déploiement** | 26 janvier 2026 |
| **Deadline soumission** | 27 janvier 2026, 08h00 |
| **Formulaire soumission** | https://forms.gle/kGtXF1n8u8oF6Y7o8 |

### Critères de notation respectés

✅ **Docker Compose** : Configuration complète dans `docker-compose.yml`  
✅ **Variables d'environnement** : Fichier `.env` séparé avec toutes les configs  
✅ **Bind volumes** : 6 volumes montés pour persistance  
✅ **Réseau user-defined** : `mattermost_network` (bridge)  
✅ **NGINX reverse proxy** : Configuration dans `nginx-23v2227.conf`  
✅ **HTTPS** : Certificat wildcard Let's Encrypt  
✅ **README complet** : Documentation exhaustive (ce fichier)  
✅ **Healthchecks** : Configurés pour Mattermost et PostgreSQL  
✅ **Script déploiement** : `deploy.sh` automatisé  

### Fichiers inclus

```
23V2227_mattermost/
├── docker-compose.yml          ✅ Configuration Docker Compose
├── .env                        ✅ Variables d'environnement
├── nginx-23v2227.conf          ✅ Configuration Nginx reverse proxy
├── deploy.sh                   ✅ Script de déploiement automatisé
├── README.md                   ✅ Documentation complète
├── .gitignore                  ✅ Exclusion fichiers sensibles
└── mattermost_app/             ✅ Bind volumes (créés au déploiement)
```

### État du déploiement

🟢 **OPÉRATIONNEL** - Application accessible et fonctionnelle

- URL : https://23v2227.systeme-res30.app
- Statut : ✅ En ligne
- SSL : ✅ Certificat valide
- Services : ✅ Mattermost + PostgreSQL running
- Healthcheck : ✅ Tous les services healthy
- WebSockets : ✅ Communication temps réel fonctionnelle
- SMTP : ✅ Emails configurés
- Backup : ✅ Procédure documentée

---

**Dernière mise à jour** : 26 janvier 2026  
**Version du README** : 2.0 (Complète et exhaustive)  

---

*Ce projet a été réalisé dans le cadre du cours INF3611 - Administration Systèmes à l'Université de Yaoundé I, Faculté des Sciences.*


### Erreur de connexion base de données
```bash
docker logs mattermost_db_23V2227
# Vérifier que PostgreSQL est healthy
docker-compose ps
```

### WebSocket ne fonctionne pas
Vérifiez la configuration Nginx, le support WebSocket est critique pour Mattermost.

---

**Bon déploiement ! 🚀**
