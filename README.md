

## Prerequisites:

A VPS running Ubuntu 20.04 (from http://txhost.fr or elsewhere)

Installation Link:
```
bash <(wget -O - 'https://raw.githubusercontent.com/TxHost/Tx-FiveM/master/tx-fivem.sh')

```
## Installation duration 

The installation time on a TxHost VPS is 02m:12s

# Start & Restart & Stop & Status your server with system commands! !
```
systemctl tx-fivem start = Start

systemctl tx-fivem restart = Restart

systemctl tx-fivem stop = Stop

systemctl tx-fivem status = Status
```

# Starting your server without system commands !

```
tx-start
```
ou

```
cd /home/fivem
bash /home/fivem/run.sh +exec server.cfg +set txAdminPort 40120
```


