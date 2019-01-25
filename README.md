# Update to BitMoney 2.2.0.2 version

- To run the script you must execute followings commands and follow the instructions:

`wget https://raw.githubusercontent.com/MutanteGithub/BitMoney/master/update_BIT22.sh -O update_BIT22.sh`

`chmod 755 update_BIT22.sh`

`./update_BIT22.sh`

- After to sync the wallets and made the tranfer of new collateral you can shutdown the all masternodes with:

`find /root /var/lib/masternodes -type f -iname "bitmoney.conf"|grep -i ".bitmoney/"|grep -v "bak"|awk '{print "/usr/local/bin/BitMoney-cli -conf="substr($0,1,length($0))" -datadir="substr($0,1,length($0)-14) " stop"}'|sh`

`systemctl -a|grep bitmoney|grep -v "failed"|awk '{print "*"$0}'|awk '{print "systemctl stop "$2}'|sh`

- And start all masternodes withfind:

`find /root  -type f -iname "bitmoney.conf"|grep -i ".bitmoney/"|grep -v "bak"|awk '{print "/usr/local/bin/BitMoneyd -daemon -reindex -conf="substr($0,1,length($0)) " -datadir="substr($0,1,length($0)-13) " -pid="substr($0,1,length($0)-13) "bitmoney.pid"}'|sh`

`find /etc/systemd/system/ -type f -name "bitmoney_*"|awk -F/ '{print "systemctl start "$5}'|sh`
