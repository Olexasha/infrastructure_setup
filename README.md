# Infrastructure Setup
Olexasha Infrastructure Repository

Описание моей работы:

## Task 5: Bastion HTTPS хост с VPN через PritUNL
Для подключения одной строкой:

    ssh -A someinternalhost@10.128.0.3 -J appuser@51.250.84.181

где:
* someinternalhost — пользователь конечной машины,
* 10.128.0.3 — IP конечной машины
* appuser — пользователь на бастионхосте,
* 51.250.84.181 — внешний IP бастионхоста

Для подключения короткой командой сделаем конфигфайл:

    > cat .\.ssh\config
    Host someinternalhost
        User someinternaluser
        HostName 10.128.0.23
        ProxyJump kek_user_ycloud@51.250.77.251
    > ssh myinternalhost
    someinternalhost@someinternalhost:~$

Домен был также добавлен, а также включено HTTPS шифрование в PritUNL.

* bastion_IP = 51.250.77.251
* someinternalhost_IP = 10.128.0.23


## Task 6: Авто деплой инстанса с окружением на YCloud

Команда для старта с метадатой (находясь в директории репы):

    >  yc compute instance create \
    >>   --name keka-reddit \
    >>   --hostname keka-reddit \
    >>   --memory=4 \
    >>   --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
    >>   --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
    >>   --metadata-from-file user-data=cloud_config.yml
    done (31s)
    ...
    fqdn: kek-reddit.ru-central1.internal
    scheduling_policy: {}
    network_settings:
      type: STANDARD
    placement_policy: {}

testapp_IP = 51.250.93.32
testapp_port = 9292

* testapp_internal_IP = 10.128.0.14
* testapp_URI = http://51.250.93.32:9292/
