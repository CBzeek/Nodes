# Gitopia Node - Mainnet

## Check logs
```
sudo journalctl -u gitopiad -f --no-hostname -o cat
```

## Check synchronization
```
gitopiad status 2>&1 | jq .SyncInfo.catching_up
```
