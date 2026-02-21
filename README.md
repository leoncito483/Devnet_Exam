# DEVASC Examen - Paso 1
- GitHub: https://github.com/leoncito483/Devnet_Exam
- Docker Hub: https://hub.docker.com/r/admin/ftp-server
- Credenciales: admin / admin

## Verificación
```bash
docker run -d --name test -p 21:21 admin/ftp-server:latest
ftp localhost  # admin/admin
```
