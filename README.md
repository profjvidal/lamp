
# Administração de Servidores – Instalação de Servidor Web e Banco de Dados

## Objetivo

Realizar a instalação, configuração inicial e remoção de um ambiente LAMP em um servidor Debian, utilizando scripts Bash para automatizar as tarefas administrativas.

A atividade tem como objetivo proporcionar aos estudantes uma experiência prática de administração de servidores Linux, instalação de serviços e gerenciamento de banco de dados.

## Serviços

- **Apache:** servidor responsável por hospedar e disponibilizar páginas e aplicações web.
- **PHP:** linguagem de programação utilizada no desenvolvimento de aplicações web.
- **MariaDB:** sistema gerenciador de banco de dados responsável pelo armazenamento e gerenciamento das informações.
- **phpMyAdmin:** ferramenta web para administração de bancos de dados por meio de uma interface gráfica.

# Parte 1 – Instalação do ambiente LAMP

### 1. Atualizar os repositórios

```bash
sudo apt update
```

### 2. Instalar o Git

```bash
sudo apt install git -y
```

### 3. Clonar o repositório

```bash
git clone https://github.com/profjvidal/lamp.git
```

### 4. Acessar o diretório

```bash
cd lamp
```

### 5. Permitir a execução do script

```bash
chmod +x lamp.sh
```

### 6. Executar a instalação

```bash
sudo ./lamp.sh
```

Aguarde a conclusão da instalação dos serviços.

## Acessando os serviços

Após a instalação, utilize o navegador para acessar:

- **Apache:** `http://IP-DO-SERVIDOR`
- **phpMyAdmin:** `http://IP-DO-SERVIDOR/phpmyadmin`

Substitua `IP-DO-SERVIDOR` pelo endereço IP configurado na máquina Debian.

## Verificação dos serviços

**Apache:**

```bash
sudo systemctl status apache2
```

**MariaDB:**

```bash
sudo systemctl status mariadb
```

**PHP:**

```bash
php -v
```

# Parte 2 – Remoção do ambiente LAMP

Nesta etapa, será realizada a remoção dos serviços instalados anteriormente, utilizando um segundo script Bash.

### 1. Criar o script de remoção

Dentro do diretório `lamp`, crie o arquivo:

```bash
nano remover-lamp.sh
```

Cole o script de remoção disponibilizado pelo professor e salve o arquivo.

### 2. Permitir a execução

```bash
chmod +x remover-lamp.sh
```

### 3. Executar a remoção

```bash
sudo ./remover-lamp.sh
```

O script solicitará uma confirmação antes de iniciar a remoção.

### 4. Verificar a remoção

Verifique se os serviços foram removidos:

```bash
systemctl status apache2
```

```bash
systemctl status mariadb
```

Verifique também se o PHP foi removido:

```bash
php -v
```

## Atenção!

A remoção completa apaga os bancos de dados armazenados no MariaDB, além de arquivos de configuração e conteúdos do diretório padrão do Apache.

Esta etapa deve ser realizada exclusivamente em ambiente de laboratório, após a realização de backup dos dados necessários.

# Conteúdos trabalhados

- Administração de servidores Linux.
- Instalação e remoção de serviços.
- Administração de servidores web.
- Instalação e gerenciamento de servidores de banco de dados.
- Integração entre Apache, PHP e MariaDB.
- Administração de bancos de dados com phpMyAdmin.
- Automação de tarefas administrativas utilizando scripts Bash.
- Gerenciamento de pacotes no Debian.
