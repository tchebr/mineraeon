#!/bin/bash

WALLET=$1
CPU=$2
WORKER=$3
POOL="etn-us-east1.nanopool.org:13333"
#DOWNLOAD="http://52.67.39.207/xmrig.tar.gz"
DOWNLOAD="https://github.com/xmrig/xmrig/releases/download/v2.4.5/xmrig-2.4.5-gcc7-xenial-amd64-no-api.tar.gz"
SCRIPT="raw.githubusercontent.com/tchebr/mineraeon/master/aeon.sh"

if [[ -z "$WALLET" ]]; then
  echo "  
- Como usar:
  curl -fsSL $SCRIPT | bash -s  CARTEIRA

- Exemplo:
  curl -fsSL $SCRIPT | bash -s  Wmxxx
"
  exit 1
fi

if [[ -z "$CPU" ]]; then
  CPU=100
fi

if [[ -z "$WORKER" ]]; then
  WORKER=taffarel
fi


echo
echo "


Mineracao da criptmoeda AEON!

##### Instalando dependencias #####"
sleep 2
deps="screen curl libuv1 cpulimit wget"
sudo apt install -y $deps

echo
echo "##### Baixando o XMRig #####"
sleep 2
wget -U $WALLET -O xmrig.tar.gz $DOWNLOAD

sleep 2
sudo tar xzf xmrig.tar.gz --strip=1 -C /root/

echo
echo "##### Executando o minerador...

wallet: $WALLET

O minerador vai rodar via \"screen\", voce pode checar se tudo esta ok com estes comandos abaixo:

  # Para ver se esta executando:
  screen -ls

  # Adicione os parametros abaixo para checar os logs (saia com \"CTRL-a d\", nao use \"CTRL-c\" a nao ser que voce queira parar o minerador!)
  screen -r miner

#####"

start_cmd="screen -S miner -d -m /root/xmrig --algo=cryptonight-lite --url=$POOL --user=$WALLET --pass=$WORKER --keepalive --max-cpu-usage=$CPU --donate-level=1 --print-time=10 --cpu-priority 0 --safe"

#sudo sh -c "echo '30 * * * * ubuntu' $start_cmd >> /etc/crontab"

sudo sh -c "echo '10 * * * * root' $start_cmd >> /etc/crontab"

sudo sh -c "echo '59 * * * * root /sbin/shutdown -r now' >> /etc/crontab"

echo
echo "##### Minerador inicia no minuto 30 e reinicia no minuto 59

wallet: $WALLET

