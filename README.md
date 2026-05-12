# Projet Boutique — Architecture Microservices

## Prérequis
- Docker & Docker Compose
- Java 21 (pour développement local)
- Flutter SDK (pour l'app mobile)
- Node.js (pour Cypress)

## Lancer le projet

```bash
# Cloner le dépôt
git clone https://github.com/votre-compte/projet-boutique.git
cd projet-boutique

# Lancer tous les services
docker-compose up --build
```

## URLs après démarrage
| Service          | URL                              |
|-----------------|----------------------------------|
| API Gateway      | http://localhost:8090            |
| produits-service | http://localhost:8091/swagger-ui.html |
| avis-service     | http://localhost:8092/swagger-ui.html |
| Eureka Dashboard | http://localhost:8761            |

## Exécuter les tests

### Tests unitaires & intégration
```bash
cd produits-service
mvn test
```

### Tests E2E Cypress
```bash
# S'assurer que docker-compose est démarré
cd projet-boutique
npm install cypress --save-dev
npx cypress run
# ou en mode interactif
npx cypress open
```

## Structure Git
- `main` : branche principale
- `version1` : Parties 1–4 (microservices + Docker)
- `version2` : Parties 5–6 (mobile + tests)