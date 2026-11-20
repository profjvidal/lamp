#!/usr/bin/env bash
set -Eeuo pipefail

trap 'echo "[ERRO] Falha na linha $LINENO. Instalação interrompida." >&2' ERR

if [[ $EUID -ne 0 ]]; then
  echo 'Execute como root: su - e depois ./lamp.sh (ou sudo ./lamp.sh).' >&2
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

echo '=== Instalação do ambiente LAMP (Debian) ==='
apt-get update
apt-get install -y apache2 mariadb-server php libapache2-mod-php php-mysql php-mbstring php-xml php-curl php-zip php-gd php-intl php-cli openssl

systemctl enable --now apache2 mariadb

# Pré-configura o phpMyAdmin para utilizar Apache e evita perguntas interativas
# do pacote; não cria automaticamente um usuário de aplicação via dbconfig-common.
echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections
# Não pré-configurar phpmyadmin/dbconfig-install: essa pergunta pode não existir
# no debconf antes da instalação do pacote em algumas versões do Debian.
apt-get install -y phpmyadmin

if [[ ! -f /etc/phpmyadmin/apache.conf ]]; then
  echo '[ERRO] Configuração /etc/phpmyadmin/apache.conf não encontrada.' >&2
  exit 1
fi

if [[ ! -e /etc/apache2/conf-available/phpmyadmin.conf && ! -L /etc/apache2/conf-available/phpmyadmin.conf ]]; then
  ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
fi

a2enconf phpmyadmin
phpenmod mbstring
apache2ctl configtest
systemctl reload apache2

# O usuário root do MariaDB permanece com autenticação local via unix_socket.
# O usuário administrativo abaixo é destinado exclusivamente a laboratórios.
if ! mariadb --protocol=socket -e 'SELECT 1' >/dev/null 2>&1; then
  echo '[ERRO] Não foi possível acessar o MariaDB como root via socket local.' >&2
  exit 1
fi

echo
read -r -s -p 'Defina uma senha forte para o usuário admin do MariaDB: ' ADMIN_PASS
echo
read -r -s -p 'Confirme a senha: ' ADMIN_CONFIRM
echo
if [[ -z "$ADMIN_PASS" || "$ADMIN_PASS" != "$ADMIN_CONFIRM" ]]; then
  echo '[ERRO] Senhas vazias ou diferentes.' >&2
  exit 1
fi

# Codifica a senha em hexadecimal para preservar caracteres especiais.
# O MariaDB monta o comando ALTER USER usando QUOTE() e SQL preparado.
PASS_HEX=$(printf '%s' "$ADMIN_PASS" | od -An -tx1 -v | tr -d ' \n')
unset ADMIN_PASS ADMIN_CONFIRM

mariadb --protocol=socket <<SQL
CREATE USER IF NOT EXISTS 'admin'@'localhost' IDENTIFIED BY 'senha_temporaria_substituida';
SET @sql = CONCAT(
  "ALTER USER 'admin'@'localhost' IDENTIFIED BY ",
  QUOTE(CONVERT(0x${PASS_HEX} USING utf8mb4))
);
PREPARE alter_admin FROM @sql;
EXECUTE alter_admin;
DEALLOCATE PREPARE alter_admin;
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost' WITH GRANT OPTION;
SQL
unset PASS_HEX

systemctl is-active --quiet apache2
systemctl is-active --quiet mariadb

IP_SERVIDOR=$(hostname -I 2>/dev/null | awk '{print $1}')
IP_SERVIDOR=${IP_SERVIDOR:-IP-DO-SERVIDOR}
echo
echo '=== Instalação concluída ==='
echo "Apache:      http://${IP_SERVIDOR}/"
echo "phpMyAdmin:  http://${IP_SERVIDOR}/phpmyadmin"
echo 'Usuário MariaDB/phpMyAdmin: admin'
echo 'Senha: a que você acabou de definir.'
echo 'ATENÇÃO: admin possui privilégios globais; utilize apenas em laboratório isolado.'
