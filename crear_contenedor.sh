
GITHUB_USER="leoncito483"
DOCKER_USER="admin"
REPO_NAME="Devnet_Exam"

if [ "$GITHUB_USER" == "tu_usuario_github" ]; then
    echo "ERROR: Debes editar el script y poner tu usuario de GitHub"
    exit 1
fi

echo " PASO 1/5 - Verificando herramientas"
sudo apt update
sudo apt install -y docker.io git ftp

echo " PASO 2/5 - Creando Dockerfile"
cat > Dockerfile << 'EOF'
FROM ubuntu:22.04
RUN apt-get update && apt-get install -y vsftpd
RUN useradd -m -s /bin/bash admin && echo "admin:admin" | chpasswd
RUN mkdir -p /home/admin/backups && chown admin:admin /home/admin/backups
RUN echo "anonymous_enable=NO" > /etc/vsftpd.conf
RUN echo "local_enable=YES" >> /etc/vsftpd.conf
RUN echo "write_enable=YES" >> /etc/vsftpd.conf
EXPOSE 21
CMD service vsftpd start && tail -f /dev/null
EOF

echo " PASO 3/5 - Construyendo imagen"
docker build -t $DOCKER_USER/ftp-server:latest .

echo " PASO 4/5 - Probando contenedor"
docker stop ftp-test 2>/dev/null
docker rm ftp-test 2>/dev/null
docker run -d --name ftp-test -p 21:21 $DOCKER_USER/ftp-server:latest
sleep 3

if docker ps | grep -q ftp-test; then
    echo " Contenedor funcionando"
else
    echo " Error: el contenedor no se inició"
    exit 1
fi

echo " PASO 5/5 - Publicando"
docker login
docker push $DOCKER_USER/ftp-server:latest

cat > README.md << EOF
# DEVASC Examen - Paso 1
- GitHub: https://github.com/$GITHUB_USER/$REPO_NAME
- Docker Hub: https://hub.docker.com/r/$DOCKER_USER/ftp-server
- Credenciales: admin / admin

## Verificación
\`\`\`bash
docker run -d --name test -p 21:21 $DOCKER_USER/ftp-server:latest
ftp localhost  # admin/admin
\`\`\`
EOF

git init
git add Dockerfile crear_contenedor.sh README.md
git commit -m "Paso 1 completo"
git branch -M main

echo "Crea el repositorio en GitHub: https://github.com/new"
echo "Nombre: $REPO_NAME"
read -p "Presiona ENTER cuando esté listo..."

git remote add origin https://github.com/$GITHUB_USER/$REPO_NAME.git
git push -u origin main

docker stop ftp-test
docker rm ftp-test

echo ""
echo "========================================"
echo "PASO 1 COMPLETADO"
echo "========================================"
echo "GitHub: https://github.com/$GITHUB_USER/$REPO_NAME"
echo "Docker: https://hub.docker.com/r/$DOCKER_USER/ftp-server"
echo "Credenciales: admin / admin"
echo "========================================"
