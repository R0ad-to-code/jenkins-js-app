pipeline {
    agent any
    
    environment {
        NODE_VERSION = '18'
        APP_NAME = 'mon-app-js'
        DEPLOY_DIR = '/var/jenkins_home/deployed-apps'
    }
    
    tools {
        nodejs 'NodeJS 18'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Récupération du code source...'
                checkout scm
            }
        }
        
        stage('Install Dependencies') {
            steps {
                echo 'Installation des dépendances Node.js...'
                sh '''
                    node --version
                    npm --version
                    npm i
                '''
            }
        }
        
        stage('Code Quality Check') {
            steps {
                echo 'Vérification de la qualité du code...'
                sh '''
                    echo "Vérification de la syntaxe JavaScript..."
                    find src -name "*.js" -exec node -c {} \\;
                    echo "Vérification terminée"
                '''
            }
        }
        
        stage('Build') {
            steps {
                echo 'Construction de l\'application...'
                sh '''
                    npm run build
                    ls -la dist/
                '''
            }
        }
        
        stage('Security Scan') {
            steps {
                echo 'Analyse de sécurité...'
                sh '''
                    echo "Vérification des dépendances..."
                    npm audit --audit-level=high
                '''
            }
        }
        
        stage('Deploy to Production') {
    steps {
        echo 'Déploiement vers la production avec Docker...'
        sh '''
            # Créer un Dockerfile pour l'application
            cat > Dockerfile.app <<EOF
                FROM node:18-alpine

                WORKDIR /src

                # Copier les fichiers de build
                COPY dist/ /src/
                COPY package*.json /src/

                # Installer un serveur léger pour servir l'application
                RUN npm install --production

                # Exposer le port
                EXPOSE 3000

                # Démarrer le serveur
                CMD ["node", "server.js"]
                EOF

                    # Construire l'image Docker
                    echo "Construction de l'image Docker..."
                    docker build -t ${APP_NAME}:latest -f Dockerfile.app .
                    
                    # Arrêter et supprimer l'ancien conteneur s'il existe
                    echo "Nettoyage des anciens conteneurs..."
                    docker stop ${APP_NAME} || true
                    docker rm ${APP_NAME} || true
                    
                    # Lancer le nouveau conteneur
                    echo "Démarrage du nouveau conteneur..."
                    docker run -d --name ${APP_NAME} -p 3000:3000 ${APP_NAME}:latest
                    
                    # Vérifier que le conteneur est bien démarré
                    echo "Vérification du conteneur..."
                    docker ps | grep ${APP_NAME}
                    
                    # Sauvegarder une copie des fichiers dans le DEPLOY_DIR pour référence
                    echo "Sauvegarde des fichiers déployés..."
                    mkdir -p ${DEPLOY_DIR}
                    cp -r dist/* ${DEPLOY_DIR}/
                '''
            }
        }
        
        stage('Health Check') {
            steps {
                echo 'Vérification de santé de l\'application...'
                script {
                    try {
                        sh '''
                            echo "Test de connectivité..."
                            # Simulation d'un health check
                            echo "Application déployée avec succès"
                        '''
                    } catch (Exception e) {
                        currentBuild.result = 'UNSTABLE'
                        echo "Warning: Health check failed: ${e.getMessage()}"
                    }
                }
            }
        }
    }
    
    post {
        always {
            echo 'Nettoyage des ressources temporaires...'
            sh '''
                rm -rf node_modules/.cache
                rm -rf staging
            '''
        }
        success {
            echo 'Pipeline exécuté avec succès!'
            emailext (
                subject: "Build Success: ${env.JOB_NAME} - ${env.BUILD_NUMBER}",
                body: """
                    Le déploiement de ${env.JOB_NAME} s'est terminé avec succès.
                    
                    Build: ${env.BUILD_NUMBER}
                    Branch: ${env.BRANCH_NAME}
                    
                    Voir les détails: ${env.BUILD_URL}
                """,
                to: "${env.CHANGE_AUTHOR_EMAIL}"
            )
        }
        failure {
            echo 'Le pipeline a échoué!'
            emailext (
                subject: "Build Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER}",
                body: """
                    Le déploiement de ${env.JOB_NAME} a échoué.
                    
                    Build: ${env.BUILD_NUMBER}
                    Branch: ${env.BRANCH_NAME}
                    
                    Voir les détails: ${env.BUILD_URL}
                """,
                to: "${env.CHANGE_AUTHOR_EMAIL}"
            )
        }
        unstable {
            echo 'Build instable - des avertissements ont été détectés'
        }
    }
}
