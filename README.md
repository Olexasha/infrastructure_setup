# Infrastructure Setup
Olexasha Infrastructure Repository

Описание моей работы:

## Task 3: Bastion HTTPS хост с VPN через PritUNL
Для подключения одной строкой:
```zsh
ssh -A someinternalhost@10.128.0.33 -J appuser@158.160.96.166
```
где:
* someinternalhost — пользователь конечной машины,
* 10.128.0.33 — IP конечной машины
* appuser — пользователь на бастионхосте,
* 158.160.96.166 — внешний IP бастионхоста

Для подключения короткой командой сделаем конфигфайл:
```zsh
>>> cat .\.ssh\config
Host someinternalhost
    User someinternaluser
    HostName 10.128.0.33
    ProxyJump kek_user_ycloud@158.160.96.166
>>> ssh myinternalhost
someinternalhost@someinternalhost:~$
```
Домен был также добавлен, а также включено HTTPS шифрование в PritUNL.

* bastion_IP = 158.160.96.166
* someinternalhost_IP = 10.128.0.33


## Task 4: Авто деплой инстанса с окружением на YCloud

Команда для старта с метадатой (находясь в директории репы):
```zsh
>>>  yc compute instance create \
>>>   --name keka-reddit \
>>>   --hostname keka-reddit \
>>>   --memory=4 \
>>>   --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
>>>   --network-interface subnet-name=kek-network-1-ru-central1-a,nat-ip-version=ipv4 \
>>>   --metadata-from-file user-data=cloud_config.yml
done (31s)
...
fqdn: kek-reddit.ru-central1.internal
scheduling_policy: {}
network_settings:
  type: STANDARD
placement_policy: {}
```

testapp_IP = 51.250.77.58
testapp_port = 9292

* testapp_internal_IP = 10.128.0.3
* testapp_URI = http://51.250.93.32:9292/
## Task 5: Автогенерация образов с помощью Packer
Команда для генерации Immutable (bake) образа (находясь в директории репы):
```zsh
>>> packer build ./packer/immutable.pkr.hcl
yandex.ubuntu16: output will be in this color.

==> yandex.ubuntu16: Creating temporary RSA SSH key for instance...
==> yandex.ubuntu16: Using as source image: fd8ohlfq53nm485ovh8k (name: "ubuntu-16-04-lts-v20230904", family: "ubuntu-1604-lts")
==> yandex.ubuntu16: Use provided subnet id e9b2848jpfr5c6mq1qa4
==> yandex.ubuntu16: Creating disk...
==> yandex.ubuntu16: Creating instance...
...
Build 'yandex.ubuntu16' finished after 9 minutes 15 seconds.

==> Wait completed after 9 minutes 15 seconds

==> Builds finished. The artifacts of successful builds are:
--> yandex.ubuntu16: A disk image was created: reddit-full-09-05-2023 (id: fd8k1rs91cqgop5qerim) with family name reddit-full
```
По аналогии запускаем стандартный (rare) образ (находясь в директории репы):
```zsh
>>> packer build ./packer/ubuntu16.pkl.hcl
```
Команда для старта создания ВМ (запускал из директории `packer`):
```zsh
>>>  yc compute instance create --name reddit-kek \
>>>    --hostname reddit-kek  \
>>>    --core-fraction=5  \
>>>    --memory=2   \
>>>    --create-boot-disk image-family=reddit-full,size=14GB   \
>>>    --network-interface subnet-name=kek-network-1-ru-central1-a,nat-ip-version=ipv4 \
>>>    --metadata serial-port-enable=1
done (1m0s)
...
fqdn: reddit-kek.ru-central1.internal
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
| fd8fbqubikpvimnbm885 | reddit-base-09-05-2023 | reddit-base | f2eh633nseu0661gm0qh | READY  |
| fd8k1rs91cqgop5qerim | reddit-full-09-05-2023 | reddit-full | f2eh633nseu0661gm0qh | READY  |
+----------------------+------------------------+-------------+----------------------+--------+
```
```zsh
>>> yc compute instances list
+----------------------+------------+---------------+---------+--------------+-------------+
|          ID          |    NAME    |    ZONE ID    | STATUS  | EXTERNAL IP  | INTERNAL IP |
+----------------------+------------+---------------+---------+--------------+-------------+
| fhm910gk4h10vq01bk9e | reddit-kek | ru-central1-a | RUNNING | 51.250.73.43 | 10.128.0.10 |
+----------------------+------------+---------------+---------+--------------+-------------+
```
## Task 6: Создание VPC инстансов с помощью Terraform
- Выполнил основные задания;
- Выполнил 1ое задание со `*`;
- Выполнил 2ое задание со `*`.

```zsh
>>> terraform version
Terraform v1.5.6
on darwin_arm64

Your version of Terraform is out of date! The latest version
is 1.5.7. You can update by downloading from https://www.terraform.io/downloads.html
```

Чтобы проверить сделанное, необходимо:
1. Выполнить:
```zsh
>>> cd ./terraform && terraform validate
Success! The configuration is valid.
```
2. Выполнить:
```zsh
>>> terraform apply -auto-approve
...
Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_app = [
  "62.84.127.111",
  "62.84.125.92",
]
external_ip_address_lb = tolist([
  "84.201.142.34",
])
```
2. Обратиться на http://84.201.142.34:80/ и убедиться, что страница открывается.
3. Зайти по ssh на 1ю ВМ:
```zsh
>>> ssh -i .ssh/yc ubuntu@62.84.127.111
ubuntu@fhmg56cuiek04otqmim0:~$ sudo systemctl stop puma
```
, проверить, что сервис отключен.
4. Обратиться на http://84.201.142.34:80/ и убедиться, что страница всё ещё открывается.
5. Потом зайти на 2ю ВМ, так же отключить puma.service и на http://84.201.142.34:80/ и убедиться, что страница уже недоступна.
