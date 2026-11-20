# Administração de Servidores – Instalação de Servidor Web e Banco de Dados

## Objetivo

Realizar a instalação, configuração inicial e remoção de um ambiente LAMP em um servidor Debian, utilizando scripts Bash para automatizar as tarefas administrativas.

A atividade tem como objetivo proporcionar aos estudantes uma experiência prática de administração de servidores Linux, instalação de serviços e gerenciamento de banco de dados.

## Serviços

- **Apache:** servidor responsável por hospedar e disponibilizar páginas e aplicações web.
- **PHP:** linguagem de programação utilizada no desenvolvimento de aplicações web.
- **MariaDB:** sistema gerenciador de banco de dados responsável pelo armazenamento e gerenciamento das informações.
- **phpMyAdmin:** ferramenta web para administração de bancos de dados por meio de uma interface gráfica.

---

## Parte 1 – Instalação do ambiente LAMP

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

### 5. Corrigir a formatação do script

Para remover possíveis quebras de linha do Windows (CRLF) e utilizar o padrão Linux (LF):

```bash
sed -i 's/\r$//' lamp.sh
```

### 6. Permitir a execução do script

```bash
chmod +x lamp.sh
```

### 7. Executar a instalação

```bash
sudo ./lamp.sh
```

Aguarde a conclusão da instalação. Durante o processo, defina uma senha forte para o usuário `admin` do MariaDB, quando solicitado.

> **Observação:** se você já estiver conectado como `root`, execute `./lamp.sh` sem `sudo`.

### Acessando os serviços

Após a instalação, abra no navegador:

- **Apache:** `http://IP-DO-SERVIDOR`
- **phpMyAdmin:** `http://IP-DO-SERVIDOR/phpmyadmin`

Substitua `IP-DO-SERVIDOR` pelo endereço IP da máquina Debian.

Para entrar no phpMyAdmin, utilize o usuário `admin` e a senha definida durante a instalação.

### Verificação dos serviços

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

---

## Parte 2 – Remoção do ambiente LAMP

Nesta etapa, será realizada a remoção dos serviços instalados anteriormente por meio do script `remover-lamp.sh`.

### 1. Acessar o diretório do projeto

```bash
cd lamp
```

Se você já estiver no diretório `lamp`, pule esta etapa.

### 2. Corrigir a formatação do script de remoção

```bash
sed -i 's/\r$//' remover-lamp.sh
```

Esse comando converte possíveis quebras de linha CRLF para LF.

### 3. Permitir a execução

```bash
chmod +x remover-lamp.sh
```

### 4. Executar a remoção

```bash
sudo ./remover-lamp.sh
```

Leia as mensagens exibidas e confirme a remoção, caso o script solicite.

> **Observação:** se você já estiver conectado como `root`, execute `./remover-lamp.sh` sem `sudo`.

### 5. Verificar a remoção

**Apache:**

```bash
systemctl status apache2
```

**MariaDB:**

```bash
systemctl status mariadb
```

**PHP:**

```bash
php -v
```

### Atenção!

A remoção completa **pode apagar permanentemente** bancos de dados do MariaDB, arquivos de configuração e conteúdos hospedados no diretório padrão do Apache, dependendo do que estiver implementado no script.

**Realize essa etapa somente em ambiente de laboratório e faça backup dos dados necessários antes da execução.**

---

## Conteúdos trabalhados

- Administração de servidores Linux.
- Instalação e remoção de serviços.
- Administração de servidores web.
- Instalação e gerenciamento de servidores de banco de dados.
- Integração entre Apache, PHP e MariaDB.
- Administração de bancos de dados com phpMyAdmin.
- Automação de tarefas administrativas utilizando scripts Bash.
- Gerenciamento de pacotes no Debian.
- Compatibilidade de scripts Bash entre Windows e Linux.
