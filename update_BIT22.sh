#!/bin/bash
 
echo ""
echo Move conf files
echo "" 

find /. -type f -name "bitmoney*.conf"|grep "bitmoney_"|grep -v "bak"|awk 'FS="_" {ori=substr($0,3,length($0)-2) ; dest=substr($2,1,length($2)-5) ; gsub("n","",dest) ; print "mv " ori " /var/lib/masternodes/bitmoney" dest"/bitmoney.conf" }'|sh

echo ""
echo Shutdown Services
echo "" 
find /. -type f -name "bitmoney.conf"|grep ".bitmoney/"|grep -v "bak"|awk '{print "/usr/local/bin/BitMoney-cli -conf="substr($0,3,length($0)-2)" -datadir="substr($0,3,length($0)-15) " stop"}'|sh
systemctl -a|grep bitmoney|awk '{print "*"$0}'|awk '{print "systemctl stop "$2}'|sh

ps -fea|grep BitMoneyd|awk '{print "kill -9 "$2}'|sh

mv /etc/masternodes /etc/masternodes_old
 
echo ""
echo Add nodes
echo "" 

find /. -type f -name "bitmoney.conf"|grep "bitmoney"|grep -v "bak"|awk '{print "echo addnode=95.179.193.119 >> "substr($0,3,length($0)-2) " ;  echo addnode=45.32.176.66 >> "substr($0,3,length($0)-2) " ;  echo addnode=95.179.197.142 >> "substr($0,3,length($0)-2) " ;  echo addnode=95.179.200.18 >> "substr($0,3,length($0)-2) }'|sh

echo ""
echo Backup Wallet.dat
echo "" 
 
find /. -type f -iname "wallet.dat"|grep "bitmoney"|grep -v "bak"|awk -v vdate=$(date +%F_%H-%M-%S) '{print "cp "$0" "$0"_bak_"vdate}'|sh

echo ""
echo Remove Old Files 
echo "" 
find /. -type f -iname "wallet.dat"|grep "bitmoney"|grep -v "bak"|awk '{print "cd "substr($0,3,length($0)-12) " ; rm -rf budget.dat banlist.dat fee_estimates.dat mncache.dat mnpayments.dat peers.dat db.log debug.log sporks"}'|sh

echo ""
echo Reinstall BIT
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

