#!/usr/bin/env bash
set -Eeuo pipefail
trap 'echo "[ERRO] Falha na linha $LINENO. Remocao interrompida." >&2' ERR

if (( EUID != 0 )); then
  echo 'Execute como root (ou com sudo, se disponivel).' >&2
  exit 1
fi

echo '=== REMOCAO COMPLETA DO AMBIENTE LAMP ==='
echo 'ATENCAO: apaga bancos MariaDB, configuracoes e /var/www/html.'
read -r -p 'Deseja continuar? (digite REMOVER): ' resposta
if [[ "$resposta" != 'REMOVER' ]]; then
  echo 'Operacao cancelada.'
  exit 0
fi

# O dbconfig-common precisa acessar o MariaDB durante o purge do phpMyAdmin.
echo '[1/5] Preparando remocao do phpMyAdmin...'
if dpkg-query -W -f='${Status}' mariadb-server 2>/dev/null | grep -q 'install ok installed'; then
  systemctl start mariadb
fi

if dpkg-query -W -f='${Status}' phpmyadmin 2>/dev/null | grep -qE 'installed|config-files|half-configured|unpacked'; then
  echo '[2/5] Removendo phpMyAdmin com MariaDB ativo...'
  DEBIAN_FRONTEND=noninteractive apt-get purge -y phpmyadmin
else
  echo '[2/5] phpMyAdmin nao esta instalado.'
fi

echo '[3/5] Removendo Apache, PHP e MariaDB...'
# Selecionar somente pacotes instalados ou com arquivos de configuracao pendentes.
mapfile -t pacotes < <(dpkg-query -W -f='${binary:Package}\t${db:Status-Abbrev}\n' 2>/dev/null | awk '$2 ~ /^(ii|rc|iU|iF|hi)/ && $1 ~ /^(apache2($|-)|libapache2-mod-php|php([0-9.]|$|-)|mariadb($|-)|mysql-common$)/ {print $1}')
if (( ${#pacotes[@]} > 0 )); then
  DEBIAN_FRONTEND=noninteractive apt-get purge -y "${pacotes[@]}"
fi

echo '[4/5] Excluindo dados e configuracoes do laboratorio...'
rm -rf -- /var/lib/mysql /etc/mysql /var/www/html /etc/php /var/log/mysql /var/log/apache2 /var/cache/apache2
# Remover apenas a configuracao criada para phpMyAdmin.
rm -f -- /etc/apache2/conf-available/phpmyadmin.conf /etc/apache2/conf-enabled/phpmyadmin.conf

echo '[5/5] Limpando dependencias...'
DEBIAN_FRONTEND=noninteractive apt-get autoremove --purge -y
apt-get autoclean

echo '=== REMOCAO CONCLUIDA ==='
