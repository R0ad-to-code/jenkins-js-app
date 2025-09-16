pipeline {
    agent any

    

    environment {
        NODE_VERSION = '18'
        APP_NAME = 'mon-app-js'
        DEPLOY_DIR = '/Library/WebServer/Documents/mon-app'
    }
    tools {
        nodejs "NodeJS"
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
        
        stage('Run Tests') {
            when {
                expression { return !params.SKIP_TESTS }
            }
            steps {
                echo 'Exécution des tests...'
                sh 'npm test'
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
        
        stage('Deploy to Staging') {
            when {
                branch 'develop'
            }
            steps {
                 echo 'Déploiement vers la production...'
                sh '''
                    echo "Sauvegarde de la version précédente..."
                    if [ -d "${DEPLOY_DIR}_staging" ]; then
                        cp -r ${DEPLOY_DIR}_staging ${DEPLOY_DIR}_staging_backup_$(date +%Y%m%d_%H%M%S)
                    fi
                    
                    echo "Déploiement de la nouvelle version..."
                    mkdir -p ${DEPLOY_DIR}_staging
                    cp -r dist/* ${DEPLOY_DIR}_staging/
                    
                    echo "Vérification du déploiement..."
                    ls -la ${DEPLOY_DIR}_staging
                '''
            }
        }
        
        stage('Deploy to Production') {
            when {
                branch 'main'
            }
            steps {
                echo 'Déploiement vers la production...'
                sh '''
                    echo "Sauvegarde de la version précédente..."
                    if [ -d "${DEPLOY_DIR}_main" ]; then
                        cp -r ${DEPLOY_DIR}_main ${DEPLOY_DIR}_main_backup_$(date +%Y%m%d_%H%M%S)
                    fi
                    
                    echo "Déploiement de la nouvelle version..."
                    mkdir -p ${DEPLOY_DIR}_main
                    cp -r dist/* ${DEPLOY_DIR}_main/
                    
                    echo "Vérification du déploiement..."
                    ls -la ${DEPLOY_DIR}_main
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
            discordSend(
                webhookURL: 'https://discord.com/api/webhooks/1417622178496512041/CZnWIH3jW3cc-mMlMcrxoMe3EmCCZYYPPP7vdTijX1JC5Xmv4BuNVntXd-yry1G-n3wW',
                title: "Build Réussi: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                description: "✅ Le déploiement de ${env.JOB_NAME} s'est terminé avec succès.",
                link: env.BUILD_URL,
                footer: "Branch: ${env.BRANCH_NAME ?: 'Non spécifiée'}",
                result: currentBuild.currentResult,
                image: 'https://jenkins.io/images/logos/jenkins/jenkins.png'
            )
        }
        failure {
            echo 'Le pipeline a échoué!'
            discordSend(
                webhookURL: 'https://discord.com/api/webhooks/1417622178496512041/CZnWIH3jW3cc-mMlMcrxoMe3EmCCZYYPPP7vdTijX1JC5Xmv4BuNVntXd-yry1G-n3wW',
                title: "⚠️ Build Échoué: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                description: "❌ Le déploiement de ${env.JOB_NAME} a échoué.",
                link: env.BUILD_URL,
                footer: "Branch: ${env.BRANCH_NAME ?: 'Non spécifiée'}",
                result: currentBuild.currentResult,
                image: 'https://jenkins.io/images/logos/jenkins/jenkins.png'
            )
        }
        unstable {
            echo 'Build instable - des avertissements ont été détectés'
        }
    }
}