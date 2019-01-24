#!/bin/bash

echo ""
echo This script update Masternode of BitMoney to 2.2.1 version
echo ""

echo ""
echo Moving conf files
echo "" 

find /. -type f -name "bitmoney*.conf"|grep "bitmoney_"|grep -v "bak"|awk 'FS="_" {ori=substr($0,3,length($0)-2) ; dest=substr($2,1,length($2)-5) ; gsub("n","",dest) ; print "mv " ori " /var/lib/masternodes/bitmoney" dest"/bitmoney.conf" }'|sh

echo ""
echo Shutdown Services
echo "" 
find /. -type f -name "bitmoney.conf"|grep ".bitmoney/"|grep -v "bak"|awk '{print "/usr/local/bin/BitMoney-cli -conf="substr($0,3,length($0)-2)" -datadir="substr($0,3,length($0)-15) " stop"}'|sh
systemctl -a|grep bitmoney|grep -v "failed"|awk '{print "*"$0}'|awk '{print "systemctl stop "$2}'|sh

ps -fea|grep BitMoneyd|awk '{print "kill -9 "$2}'|sh

mv /etc/masternodes /etc/masternodes_old
 
echo ""
echo Adding nodes
echo "" 

find /. -type f -name "bitmoney.conf"|grep "bitmoney"|grep -v "bak"|awk '{print "echo addnode=95.179.193.119 >> "substr($0,3,length($0)-2) " ;  echo addnode=45.32.176.66 >> "substr($0,3,length($0)-2) " ;  echo addnode=95.179.197.142 >> "substr($0,3,length($0)-2) " ;  echo addnode=95.179.200.18 >> "substr($0,3,length($0)-2) }'|sh

echo ""
echo Backuping Wallet.dat
echo "" 
 
find /. -type f -iname "wallet.dat"|grep "bitmoney"|grep -v "bak"|awk -v vdate=$(date +%F_%H-%M-%S) '{print "cp "$0" "$0"_bak_"vdate}'|sh

echo ""
echo Removing Old Files 
echo "" 
find /. -type f -iname "wallet.dat"|grep "bitmoney"|grep -v "bak"|awk '{print "cd "substr($0,3,length($0)-12) " ; rm -rf budget.dat banlist.dat fee_estimates.dat mncache.dat mnpayments.dat peers.dat db.log debug.log sporks"}'|sh

echo ""
echo Reinstalling BIT
echo "" 

wget -O - https://github.com/CryptVenture/BitMoneyV22/releases/download/2.2.0.1/BitMoney-2.2.0.1-Linux-16.04.tar.gz | tar -xzC /usr/local/bin
apt-get -qq install miniupnpc
apt-get -qq install libzmq5

echo ""
echo Startup Services
echo "" 

find /. -type f -name "bitmoney.conf"|grep ".bitmoney/"|grep -v "bak"|awk '{print "/usr/local/bin/BitMoneyd -daemon -reindex -conf="substr($0,3,length($0)-2) " -datadir="substr($0,3,length($0)-15) " -pid="substr($0,3,length($0)-15) "bitmoney.pid"}'|sh

find /. -type f -name "bitmoney.conf"|grep ".bitmoney"|grep -v ".bitmoney/"|grep -v "bak"|awk '{print "su masternode -c \"/usr/local/bin/BitMoneyd -daemon -reindex -conf="substr($0,3,length($0)-2) " -datadir="substr($0,3,length($0)-15) " -pid="substr($0,3,length($0)-15) "bitmoney.pid\""}'|sh

#Getinfo 
sleep 40
find /. -type f -name "bitmoney*.conf"|grep "bitmoney"|grep -v "bak"|awk '{print "/usr/local/bin/BitMoney-cli -conf="substr($0,3,length($0)-2)" getinfo"}'|sh

echo ""
echo Now deposit the collaterals in a wallets and edit the masternodes.conf files updating the TXID
echo and restart the services.
echo ""
echo Enjoy.
