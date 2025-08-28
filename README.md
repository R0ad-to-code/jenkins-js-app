# Installer Jenkins sur mac
Pour intaller Jenkins, j'ai suivi les etapes https://github.com/formationrossignol/tp-cicd/blob/main/installation-jenkins.md

Pour avoir le mdp initial, j'ai du prendre le path proposé par Jenkins. 

![alt text](<Screenshot 2025-08-28 at 1.23.24 PM.png>)


# créer et configurer un pipeline Jenkins
1. mettre en place le git avec application node.js et un fichier jenkins. 

2. installer les plugins (node.js sur jenkins)
2bis. ajouter le tool NodeJS dans les reglages tools

3. création Pipeline Jenkins avec le git de mon projet avec trigger hook trigger for GITScm polling
- installation GitHub Integration Plugin
- GitHub Authentication

- ajout credentials dans les secrets jenkins
- ajout webhook sur github -> lors d'un projet en jenkins en local, il faut créer un tunnel sécurisé ou ouvrir un port avec l'adresse ip publique

par practicité, je mets juste en place un pull SCM toutes les 5 minutes H/5 * * * *

4. modification file Jenkins -> 
- ajout tool NodeJS + 
- correction npm ci -> npm i (npm ci nécéssite un package-lock.json)
- effacer "publishTestResults"

5. deployer sur 2 branches
pour cela il faut créer un autre pipeline de format "multibranch"

6. pour deployer, il faut donner le droit au dossier var/www/html/ à jenkins



# Partie 5 : Questions et Réflexions
Quelle est la différence entre npm install et npm ci dans le contexte CI/CD?

npm ci (clean install) reprend les dependances du package-lock.json. Dans du CI/CD, où l'on veut garantir la reproductibilité et cohérence du projet.


Pourquoi utilise-t-on des conditions when dans certaines étapes?

Cela permet de mettre de condition, comme ici la branche sur laquelle a été push


Comment fonctionne la gestion des erreurs avec les blocs post?

Ce sont des sections qui toujours executées permettant d'executer des actions après la fin du pipeline. C'est beaucoup utilisé pour du log.


Quel est l'intérêt de faire un backup avant déploiement?

Le but est de pouvoir revenir en arrière si le deploy fail et que le dossier a déj été mis à jour.