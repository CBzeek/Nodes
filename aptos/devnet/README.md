# Aptos DevNet
## **Prepare for install:**
```
sudo apt install screen -y && screen -S aptos
```

## **Install aptos node:**
```
wget -q https://github.com/CBzeek/Nodes/raw/main/aptos/devnet/aptos-devnet.sh && chmod +x aptos-devnet.sh && sudo /bin/bash aptos-devnet.sh
```

## **Check chain_id, epoch and ledger_version:**
```
curl --request GET --url $(wget -qO- eth0.me):8080/ --header 'Content-Type: applicaticlearon/json' && echo ''
```

## **Check metrics:**
```
curl 127.0.0.1:9101/metrics 2> /dev/null | grep aptos_state_sync_version
```

## **Check logs:**
```
journalctl -u aptosd -f
```

## **Restart node:**
```
systemctl restart aptosd
```
## Check node
[Aptos devnet explorer](https://explorer.devnet.aptos.dev/)

[Aptos Node Informer by Serhii Pimenov](https://aptos-node.info/)

[APTOS TESTER by Andrew | zValid](https://node.aptos.zvalid.com/)

