#!/bin/bash

# Atualizar repositórios e pacotes
sudo apt update
sudo apt upgrade -y

# Baixar o pacote do Zabbix
sudo wget https://repo.zabbix.com/zabbix/6.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.4-1+ubuntu20.04_all.deb

# Instalar o pacote do Zabbix
sudo dpkg -i zabbix-release_6.4-1+ubuntu20.04_all.deb
sudo apt update -y

# Instalar o servidor Zabbix e o frontend
sudo apt install -y zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent mysql-server

echo "Módulos instalados."

# Definir a senha do usuário root
echo "root:P@ssW0rD" | sudo chpasswd

# Criar arquivo de configuração do MySQL
sudo tee /etc/mysql/my.cnf > /dev/null <<EOF
[client]
password=P@ssW0rD
EOF

# Reiniciar o serviço do MySQL
sudo systemctl restart mysql

echo "Banco de Dados configurado"

# Criar usuário e conceder permissões
sudo mysql -uroot -pP@ssW0rD <<EOF
CREATE USER 'zabbix'@'localhost' IDENTIFIED BY 'P@ssW0rD';
GRANT ALL PRIVILEGES ON *.* TO 'zabbix'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

# Criar banco de dados para o Zabbix
sudo mysql -uzabbix -pP@ssW0rD <<EOF
CREATE DATABASE zabbix character set utf8mb4 collate utf8mb4_bin;
EOF

echo "Banco de dados configurado no Zabbix"

# Importar esquema e dados iniciais para o banco de dados do Zabbix
sudo zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | sudo mysql -uzabbix -pP@ssW0rD zabbix

# Configurar o banco de dados no arquivo de configuração do Zabbix
sudo sed -i 's/DBHost=localhost/DBHost=localhost/' /etc/zabbix/zabbix_server.conf
sudo sed -i 's/DBName=zabbix/DBName=zabbix/' /etc/zabbix/zabbix_server.conf
sudo sed -i 's/DBUser=zabbix/DBUser=zabbix/' /etc/zabbix/zabbix_server.conf
sudo sed -i 's/# DBPassword=/DBPassword=P@ssW0rD/' /etc/zabbix/zabbix_server.conf

echo "Serviços iniciados."

# Reiniciar serviços
sudo systemctl restart zabbix-server zabbix-agent apache2
sudo systemctl enable zabbix-server zabbix-agent apache2

# Limpar arquivos de instalação
rm zabbix-release_6.4-1+ubuntu20.04_all.deb

# Obter e exibir o endereço IP da VM 
ip_address=$(ip addr | awk '/inet / {print substr($2,1)}' | head  && echo '')

# Exibir o endereço IP
echo "O endereço IP da VM é: $ip_address"

echo "A instalação do Zabbix foi concluída."
