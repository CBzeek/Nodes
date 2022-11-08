#!/bin/bash
cd $HOME

PROJECT_NAME="nibid"

#Backup
if [ -d $HOME/.$PROJECT_NAME/config ]; then
    echo ''
    echo -e "\e[1m\e[32m### Backup configuration files... \e[0m" && sleep 1
    echo ''
    cd $HOME
    backup_dir=$HOME/$PROJECT_NAME_backup_$(date +%F--%R)
    mkdir $backup_dir
    rsync -av --exclude='data' --exclude='wasm' $HOME/.$PROJECT_NAME/ $backup_dir
else
    echo ''
fi

#Stop service
echo ''
echo -e "\e[1m\e[32m### Stopping $PROJECT_NAME service... \e[0m" && sleep 1
echo ''
sudo systemctl stop nibid

#Update peers
echo ''
echo -e "\e[1m\e[32m### Updating $PROJECT_NAME peers... \e[0m" && sleep 1
echo ''
peers="b32bb87364a52df3efcbe9eacc178c96b35c823a@nibiru-testnet.nodejumper.io:27656,5c30c7e8240f2c4108822020ae95d7b5da727e54@65.108.75.107:19656,dd8b9d6b2351e9527d4cac4937a8cb8d6013bb24@185.165.240.179:26656,55b33680faaad0889dddcd940c4e7f77cc74186a@194.163.151.154:26656,31b592b7b8e37af2a077c630a96851fe73b7386f@138.201.251.62:26656,97e599a3709d73936217e469bcea4cd1e5d837a0@178.62.24.214:39656,5eecfdf089428a5a8e52d05d18aae1ad8503d14c@65.108.141.109:19656,7ddc65049ebdab36cef6ceb96af4f57af5804a88@77.37.176.99:16656,9007f52d9f46c581bf4a0fc6f4a108699caa4676@135.181.83.112:39656,7dbd7ee1ca5870ac16a3e276d0643862be0b1da6@82.135.241.163:26656,2fc98a228dee1826d67e8a2dbd553989118a49cc@5.9.22.14:60656,2cd56c7b5d19b60246960a92b928a99d5c272210@154.26.138.94:26656,ff597c3eea5fe832825586cce4ed00cb7798d4b5@65.109.53.53:26656,ab5255a0607b7bdde58b4c7cd090c25255503bc6@199.175.98.111:36656,6369e3aefce2560b2073913d9317b3e9a0b06ab5@65.108.9.25:39656,16a5f0db538cafa0399c5a2b32b1d014b17932d4@162.55.27.100:39656,dc9554474fab76a9d62d4ab5d833f9fa7487a4eb@20.115.40.141:39656,35d8f676cf4db0f4ed7f3a8750daf8010797bdc4@135.181.116.109:20086,4be11bdbbab4541f7b663bcae8367928d48d3c4c@131.153.203.247:39656,ac8e43ccbdf25be95d7b85178c66f45453df0c7d@94.103.91.28:39656,257350f620db24cf68f0c923a0bb40b1263494e3@95.216.100.99:39656,1004b58a7925cec67a36e41222474e44f0719ff5@5.161.124.79:39656,e977310b55bf8d50644647d0e30f272eddac12e8@65.108.58.98:36656,2ca221b94783ceae09ad6968b0268430080a01bb@49.12.216.13:60656,c9dcc45a1c3183f0df5751da6f5f7ae6f08138fd@188.134.69.27:26656,0005281ba0d809e23f28c4a11203c3a77a9117a6@161.97.149.239:26656,6d889e913f670ebdeaf3aa19fbf747611e94eb59@45.94.209.252:39656,c5f3caef6a57b28b0a136c80c3b6165dd6d57fe2@65.109.27.156:26656,833a4ce4b51c81bbbb41dad7ff9733080e8232e9@154.26.132.181:26656,ca251c4c914c0c70a32a2fdc00a6ea519a0a8856@45.141.122.178:26656,da16e5029e1daf6583a258b0f6c8b5e484b043ca@75.119.143.229:26656,4eedc2562e60c9df5801bb21ebbda141c700b231@49.51.97.131:26656,c3efbf90e5d85b989dd4abc7314d00cb29814e32@80.82.222.221:39656,65436a8aba0cd3809a79c3c4c5a53e70eb6d6ba4@128.199.219.116:39656,8db425e1e80097c2281d35dad79de40e0c3ba033@154.53.40.178:26656,da6cabfdbb17e1eb03ae3fbf9fab2f9444e2eec8@194.5.152.22:26656,199f4c785ab50872cf67bc85cfe68ea22d456e2e@161.97.133.62:39656,c6201387cfba949acd82dc387bd04605c1160ed2@185.216.203.66:26656,822611ebd0e93059eb3c5deadc4854b9fca29aa5@185.180.199.240:26656,2a3bbb85269425894be623e5f70453fd8a00313f@5.161.128.224:26656,e46dcf317312ec89a3c2fb1cc2e55d3fd9b20534@217.160.25.118:39656,64e7e467b907280184bd5e5417b297b1874d164b@135.181.20.44:2486,8b6813f1252704d74146a5959798439cb326d4ec@88.198.85.99:26656,334d2fc176f0f94b8aec7ca003f9d1bd41280cde@95.217.157.210:26656,3f294652d5ecac9497a9c3f8a96147bcf5ba43ec@95.111.238.216:26656,5c38d58ce4a5960ca65ce0e8030d3d087254285f@167.235.145.85:26656,e70887c834dcb12907425c1ba926246f8dc1210f@161.97.165.195:26656,bcb512c885af3a3c26cf0b09b7a0c060e7064703@167.235.145.81:26656,59b8c9700e68851491b82f2e82bd7634c11fa410@65.21.237.156:26656,bbb538252837bfabda54342298961af7ee6c5ac4@167.235.145.73:26656,a2162bd42fdb011eb821d62fcaed3276142cf4d4@142.132.139.101:26656,c267e06a6a84d17e09b0593a500fa86d2bf51423@45.83.122.25:26656,0d8e583ce397f49985594393db2f4d23ca4b5c6e@109.123.250.174:26656,a526683322dd833819e05300940520445f3d3885@109.123.250.62:26656,4edc2bf88d74b3af030c202b56b39af544581799@72.44.68.72:26656,095cc77588be94bc2988b4dba86bfb001ec925ff@135.181.111.204:26656,1e96ed7f007b2b4b83707e9e7ff26cb3b110870a@185.130.251.31:26656,faa3bcc37a43c1a8de879650215417bf27039086@157.90.252.194:16656,95c69b390f7adfc23b682a420bc54f63741071ab@164.68.110.151:39656,2134192d030d73295091400cf9440c331bdb68df@5.161.138.61:26656,08585fd88bc658e2896d9c0d944f058be66e7d04@164.68.110.167:39656,27c1bfd195aab3d98f7d7194942abcc125212696@167.235.145.80:26656,6c823618be0c0d8413d04d3a2e2684c4a0dd6694@185.200.34.172:39656,35167908725bb24e4a9aa4ebaff5acf342199322@34.23.74.1:26656,c2b3b3304b8061f9d8a1a781066947737a8d8fbc@82.165.222.163:26656,18b0c561138b4a1e84c01315c09bfb866404c28a@135.181.223.165:39656,62f26443c930a02f3e166b9db4ecd37b65b042f2@49.12.8.255:26656,de29ceedb6e7e7f1606c9b3ae9266da8d2e82d38@45.140.185.206:26656,433a3c1406efcdf53a244700bcff7c9d9a725ce7@199.175.98.120:26656,b12d34c7d9465b1096795cba292cc74d5e201866@88.198.85.100:26656,a6706700dc43ab94c53bacecea2653752f757604@34.64.229.42:26656,8eb25788a0d20ca5becb6dcda6f76b0a83b13d10@95.217.224.252:26656,7d564851905ef549b651c0df94acdf99521a162b@49.12.218.145:16656,1275f7794724aeafdbe22c6d2aba722145111ce3@164.68.110.36:39656,b135db9dc9d4b95bfae4f1ffbe095a91442dc3dc@167.235.145.49:26656,e2d7153833930824626201a94bf5f93b1d9dba11@167.235.145.86:26656,dd2a68405c170f14211a0c50ab6e0c1d48b4faf3@207.180.242.141:26656,da5d8ca885f4b74a93911d8e6db229435ef306ef@178.128.108.23:39656,9a25335865c3d16d8d660e5256db45e73b54b707@109.123.250.173:26656,ae4179f53d535b94fb588573b360c71a07ad55ab@46.53.245.40:39656,f1001582f5c0b9b67e220d1d53432333917d247d@62.171.149.136:39656,22e9680de9de88e4686c1705ee0ab8a08fb26cdd@88.210.9.78:26656,c254158a0400956d8ec525f291998f82a62675f5@74.208.252.106:26656,056c8be87aa2a4bc67c96c4b5ada0ad6e3d5c607@207.180.241.98:26656,7a462d07fbba56aa773a105aba232916395cd184@167.86.115.153:16656,3dbaa4a9b957ac296e197083d120f94112c45607@161.97.115.131:26656,945357ab142441c71f8a51093d741459e70a5b24@161.97.173.33:26656,23a18fe03c6c1b0ccc7eb0d53716ef2ba5887fd3@194.5.152.200:26656,38a305d0e5f9fa0c131656cf98118767089e4cda@154.26.138.215:26656,ef2256f8f38d5a6bf2784410cf1454ac8802cb7d@188.226.121.172:26656,5be94d5bfb2ac047c969b143c0d8f0c401b55961@194.163.141.50:26656,9fb429a651f11631d9aa9b0e61d41c747748178d@38.242.133.191:26656,706e0f388ed681d193b8066bec7586d2e1c2ef32@185.177.116.221:36656,2e659cbba0d07ed1be552cc5b6cba116d53aa3ea@109.123.251.157:26656,d9d716ad1d94a662f1e4c646619da14d6cf3aa35@88.210.3.200:26656,65e7b45e919bac536e998119d80a16a807bdce5b@213.202.231.29:26656,932ceb4e66f2d926acfd2c7c5a26a08f07e19231@20.247.94.106:39656,9288e8ab4f01383ac1864ddcb7f9eccc4c2e8810@83.171.248.175:39656,67fa991e201f4088fc711336aff66e24b1cf5e2b@65.108.129.104:21656,552c3565ab5202f64019c49932c69abf56e08d4b@5.161.121.242:39656"
sed -i 's|^persistent_peers *=.*|persistent_peers = "'$peers'"|' $HOME/.$PROJECT_NAME/config/config.toml

#Restart service
echo ''
echo -e "\e[1m\e[32m### Starting okp4 service... \e[0m" && sleep 1
echo ''
sudo systemctl restart nibid
