
#!/bin/bash

# Remocao completa do ambiente LAMP no Debian

if [ "$EUID" -ne 0 ]; then
    echo "Execute este script como root ou utilizando sudo."
    exit 1
fi

echo "======================================"
echo " REMOCAO COMPLETA DO AMBIENTE LAMP"
echo "======================================"

echo ""
echo "ATENCAO: Esta operacao removera:"
echo "- Apache"
echo "- PHP e extensoes"
echo "- MariaDB"
echo "- phpMyAdmin"
echo "- Bancos de dados"
echo "- Arquivos e configuracoes"

echo ""
read -p "Deseja continuar? (s/N): " resposta

if [[ ! "$resposta" =~ ^[sS]$ ]]; then
    echo "Operacao cancelada."
    exit 0
fi

echo ""
echo "[1/5] Parando os servicos..."

systemctl stop apache2 2>/dev/null
systemctl stop mariadb 2>/dev/null

echo "[2/5] Removendo Apache, PHP e phpMyAdmin..."

apt purge -y \
    apache2 \
    apache2-bin \
    apache2-data \
    apache2-utils \
    libapache2-mod-php* \
    php* \
    phpmyadmin

echo "[3/5] Removendo MariaDB..."

apt purge -y \
    mariadb-server \
    mariadb-client \
    mariadb-common \
    mariadb-server-core* \
    mariadb-client-core*

echo "[4/5] Removendo arquivos e diretorios..."

rm -rf /var/lib/mysql
rm -rf /etc/mysql
rm -rf /var/www/html
rm -rf /etc/php
rm -rf /var/log/mysql
rm -rf /var/log/apache2
rm -rf /var/cache/apache2

echo "[5/5] Limpando dependencias..."

apt autoremove --purge -y
apt autoclean

echo ""
echo "======================================"
echo " REMOCAO CONCLUIDA!"
echo "======================================"
