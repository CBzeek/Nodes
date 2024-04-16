#  0g Node

## 0g Node v1.0.0-testnet install
```
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/0g/v1.0.0-testnet/0g.sh')

```

## 0g Node v1.0.0-testnet snapshot
```
source <(wget -qO- 'https://raw.githubusercontent.com/CBzeek/Nodes/main/0g/v1.0.0-testnet/0g-snapshot.sh')

```




sudo systemctl restart ogd

sudo journalctl -u ogd -f -o cat

evmosd status | jq .SyncInfo

echo "0x$(evmosd debug addr $(evmosd keys show $WALLET_NAME -a) | grep hex | awk '{print $3}')"

evmosd q bank balances $(evmosd keys show $WALLET_NAME -a)


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


