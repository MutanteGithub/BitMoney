# Update to BitMoney 2.2.1 

- To run the script you must execute followings commands and follow the instructions:

wget https://raw.githubusercontent.com/MutanteGithub/BitMoney/master/update_BIT22.sh -O update_BIT22.sh

chmod 755 update_BIT22.sh

./update_BIT22.sh

- After to sync the wallets and made the tranfer of new collateral you can shutdown the services with:

find /root /var/lib/masternodes -type f -name "bitmoney.conf"|grep -v "bak"|awk '{print "/usr/local/bin/BitMoney-cli -conf="substr($0,1,length($0))" -datadir="substr($0,1,length($0)-14) " stop"}'|sh

- And start with:

find /root  -type f -name "bitmoney.conf"|grep ".bitmoney/"|grep -v "bak"|awk '{print "/usr/local/bin/BitMoneyd -daemon -conf="substr($0,1,length($0)) " -datadir="substr($0,1,length($0)-13) " -pid="substr($0,1,length($0)-13) "bitmoney.pid"}'|sh

find /var/lib/masternodes/ -type f -name "bitmoney.conf"|grep ".bitmoney"|grep -v ".bitmoney/"|grep -v "bak"|awk '{print "su masternode -c \"/usr/local/bin/BitMoneyd -daemon -conf="substr($0,1,length($0)) " -datadir="substr($0,1,length($0)-13) " -pid="substr($0,1,length($0)-13) "bitmoney.pid\""}'|sh
