# Infrastructure Setup
Olexasha Infrastructure Repository

Описание моей работы:
## Task 5: Bastion HTTPS хост с VPN через PritUNL
Для подключения одной строкой:
```zsh
>>> ssh -A someinternalhost@10.128.0.3 -J appuser@51.250.84.181
```
, где:
* someinternalhost — пользователь конечной машины,
* 10.128.0.3 — IP конечной машины
* appuser — пользователь на бастионхосте,
* 51.250.84.181 — внешний IP бастионхоста

Для подключения короткой командой сделаем конфигфайл:
```zsh
>>> cat .\.ssh\config
    Host someinternalhost
        User someinternaluser
        HostName 10.128.0.23
        ProxyJump kek_user_ycloud@51.250.77.251
>>> ssh myinternalhost
    someinternalhost@someinternalhost:~$
```
Домен был также добавлен, а также включено HTTPS шифрование в PritUNL.
* bastion_IP = 51.250.77.251
* someinternalhost_IP = 10.128.0.23

## Task 6: Авто деплой инстанса с окружением на YCloud
Команда для старта с метадатой (находясь в директории репы):
```zsh
>>>  yc compute instance create \
>>>   --name keka-reddit \
>>>   --hostname keka-reddit \
>>>   --memory=4 \
>>>   --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
>>>   --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
>>>   --metadata-from-file user-data=cloud_config.yml
        done (31s)
        ...
        fqdn: kek-reddit.ru-central1.internal
        scheduling_policy: {}
        network_settings:
          type: STANDARD
        placement_policy: {}
```
* testapp_IP = 51.250.93.32
* testapp_port = 9292
* testapp_internal_IP = 10.128.0.14
* testapp_URI = http://51.250.93.32:9292/
## Task 7: Автогенерация образов с помощью Packer
Команда для генерации Immutable (bake) образа (находясь в директории репы):
```zsh
>>> packer build ./packer/immutable.json
        yandex: output will be in this color.
        ==> yandex: Creating temporary RSA SSH key for instance...
        ==> yandex: Using as source image: fd861besjahbghg5ek3k (name: "ubuntu-16-04-lts-v20230522", family: "ubuntu-1604-lts")
        ==> yandex: Use provided subnet id e9bv8bigjkpoiecm8aro
        ==> yandex: Creating disk...
        ==> yandex: Creating instance...
        ...
        yandex: ● puma.service - Puma HTTP Server
        yandex:    Loaded: loaded (/etc/systemd/system/puma.service; enabled; vendor preset: enabled)
        yandex:    Active: activating (auto-restart) (Result: exit-code) since Thu 2023-05-25 01:26:34 UTC; 4ms ago
        yandex:   Process: 9702 ExecStart=/usr/local/bin/puma (code=exited, status=217/USER)
        yandex:  Main PID: 9702 (code=exited, status=217/USER)
        Build 'yandex' finished after 8 minutes 40 seconds.
        ==> Wait completed after 8 minutes 40 seconds
        ==> Builds finished. The artifacts of successful builds are:
        --> yandex: A disk image was created: reddit-bake-1684977530 (id: fd8ve51itv7v7rhvtnb4) with family name reddit-full
```
По аналогии запускаем стандартный (rare) образ (находясь в директории репы):
```zsh
>>> packer build ./packer/ubuntu16.json
        yandex: output will be in this color.
        ...
        Build 'yandex' finished after 3 minutes 21 seconds.
        ==> Wait completed after 3 minutes 21 seconds
        ==> Builds finished. The artifacts of successful builds are:
        --> yandex: A disk image was created: reddit-base-1684978707 (id: fd86m5v14i4mb2c2ru0d) with family name reddit-base
```
Команда для старта создания ВМ (запускал из директории `packer`):
```zsh
>>>  yc compute instance create --name reddit-app \
>>>    --hostname reddit-app  \
>>>    --core-fraction=5  \
>>>    --memory=2   \
>>>    --create-boot-disk image-family=reddit-full,size=14GB   \
>>>    --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
>>>    --metadata serial-port-enable=1
        done (1m0s)
        ...
        fqdn: reddit-app.ru-central1.internal
        scheduling_policy: {}
        network_settings:
          type: STANDARD
        placement_policy: {}
```
Пруфы:
```zsh
>>> yc compute image list
+----------------------+------------------------+-------------+----------------------+--------+
|          ID          |          NAME          |   FAMILY    |     PRODUCT IDS      | STATUS |
+----------------------+------------------------+-------------+----------------------+--------+
| fd86m5v14i4mb2c2ru0d | reddit-base-1684978707 | reddit-base | f2e1ebb38bt8hp89n3iu | READY  |
| fd8ve51itv7v7rhvtnb4 | reddit-bake-1684977530 | reddit-full | f2e1ebb38bt8hp89n3iu | READY  |
+----------------------+------------------------+-------------+----------------------+--------+
```
