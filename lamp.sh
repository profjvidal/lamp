
#!/bin/bash

# Instalação automática do LAMP no Debian

if [ "$EUID" -ne 0 ]; then
    echo "Execute este script como root."
    exit 1
fi

echo "=================================="
echo " INSTALACAO DO SERVIDOR LAMP"
echo "=================================="

echo "[1/4] Atualizando repositórios..."
apt update

echo "[2/4] Instalando Apache, MariaDB e PHP..."
apt install -y \
    apache2 \
    mariadb-server \
    mariadb-client \
    php \
    libapache2-mod-php \
    php-cli \
    php-mysql \
    php-curl \
    php-gd \
    php-mbstring \
    php-xml \
    php-zip

echo "[3/4] Instalando phpMyAdmin..."
apt install -y phpmyadmin

echo "[4/4] Ativando serviços..."

systemctl enable apache2
systemctl enable mariadb

systemctl restart mariadb
systemctl restart apache2

echo "=================================="
echo " INSTALACAO CONCLUIDA!"
echo "=================================="

echo "Apache: http://localhost"
echo "phpMyAdmin: http://localhost/phpmyadmin"
echo ""
echo "Versao do PHP:"
php -v

echo ""
echo "Status dos servicos:"
systemctl is-active apache2
systemctl is-active mariadb

echo "=================================="
