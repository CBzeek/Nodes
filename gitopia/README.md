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
