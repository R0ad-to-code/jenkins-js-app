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