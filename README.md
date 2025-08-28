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



