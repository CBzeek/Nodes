#  0g Node

## 0g Node v1.0.0-testnet install
```
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/0g/v1.0.0-testnet/0g.sh')

```

## 0g Node v1.0.0-testnet snapshot
```
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/0g/v1.0.0-testnet/snapshot.sh')

```




sudo systemctl restart ogd

sudo journalctl -u ogd -f -o cat

evmosd status | jq .SyncInfo


