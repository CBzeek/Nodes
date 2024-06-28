#  0g Node - zgtendermint_16600-2

## Screen
```
sudo apt install screen -y && screen -Rd 0g
```

## Install
```
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/0g/zgtendermint_16600-2/0g.sh')
```

## Snapshot
```
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/0g/zgtendermint_16600-1/0g-snapshot.sh')
```

## Address Book
```
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/0g/v1.0.0-testnet/0g-addrbook.sh')
```

## Create validator
```
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/0g/zgtendermint_16600-1/0g-validator.sh')
```

## Backup private key
```
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/0g/zgtendermint_16600-1/0g-backup.sh')
```








## Other
0gchaind keys show $WALLET_NAME --bech val -a

sudo systemctl restart ogd

sudo journalctl -u ogd -f -o cat

0gchaind status | jq .sync_info

echo "0x$(evmosd debug addr $(evmosd keys show $WALLET_NAME -a) | grep hex | awk '{print $3}')"

0gchaind q bank balances $(0gchaind keys show $WALLET_NAME -a)

0gchaind tx staking delegate YOUR_VALIDATOR_ADDRESS 100000ua0gi --from $WALLET_NAME --gas=auto --gas-adjustment=1.4 -y






Устанавливаем addrbook.json
sudo systemctl stop ogd && \
wget -O $HOME/.evmosd/config/addrbook.json https://rpc-zero-gravity-testnet.trusted-point.com/addrbook.json
Бэкап файла priv_validator_state.json
cat $HOME/.evmosd/config/priv_validator_key.json
Запрос счетчика пропущенных блоков и сведений о тюрьме вашего валидатора
evmosd q slashing signing-info $(evmosd tendermint show-validator)
Unjail валидатора
evmosd tx slashing unjail --from $WALLET_NAME --gas=500000 --gas-prices=99999aevmos -y
Отправить токены между кошельками <TO_WALLET> и <AMOUNT> заменяем на свои значения
evmosd tx bank send $WALLET_NAME <TO_WALLET> <AMOUNT>aevmos --gas=500000 --gas-prices=99999aevmos -y
Запросить список активных валидаторов
evmosd q staking validators -o json --limit=1000 \
| jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' \
| jq -r '.tokens + " - " + .description.moniker' \
| sort -gr | nl
Запросить список неактивных валидаторов
evmosd q staking validators -o json --limit=1000 \
| jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' \
| jq -r '.tokens + " - " + .description.moniker' \
| sort -gr | nl
Посмотреть логи
sudo journalctl -u ogd -f -o cat
Проверить статус синхронизации
evmosd status | jq .SyncInfo
Статус ноды
evmosd status | jq
Рестарт
sudo systemctl restart ogd
Остановить ноду
sudo systemctl stop ogd
Удалить ноду
sudo systemctl stop ogd
sudo systemctl disable ogd
sudo rm /etc/systemd/system/ogd.service
rm -rf $HOME/.evmosd $HOME/0g-evmos


