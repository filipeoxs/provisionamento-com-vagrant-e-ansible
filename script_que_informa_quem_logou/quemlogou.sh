#!/bin/bash

# Defina o diretório onde o arquivo .txt será armazenado
LOG_FILE="/home/DLIPEA/login.txt"

# Função para registrar o login no arquivo .txt
function registrar_login {
    echo "$(date) - Usuário $USER fez login" >> "$LOG_FILE"
}

# Execute a função registrar_login sempre que um usuário fizer login
trap 'registrar_login' INT TERM EXIT

# Defina o diretório na VM onde você deseja salvar o arquivo .txt
LOCAL_DIR="/home/DLIPEA/"

# Certifique-se de que o diretório existe e tem as permissões adequadas
mkdir -p "$LOCAL_DIR"
chmod 777 "$LOCAL_DIR"

# Loop infinito para manter o script em execução 24x7
while true; do
    # Aguarde 1 minuto antes de registrar novamente
    sleep 1
done
