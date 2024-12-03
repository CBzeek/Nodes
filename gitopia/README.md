# Gitopia Node - Mainnet

## Check logs
```
sudo journalctl -u gitopiad -f --no-hostname -o cat
```

## Check synchronization
```
gitopiad status 2>&1 | jq .SyncInfo.catching_up
```

## Screen
```
sudo apt install screen -y && screen -Rd gitopia
```

## Install
```
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/gitopia/mainnet/install.sh')
```

## Create Validator
```
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/gitopia/mainnet/validator.sh')
```

## Snapshot
```
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/gitopia/mainnet/snapshot.sh')
```

## Backup
```
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/refs/heads/main/gitopia/mainnet/backup.sh')
```
