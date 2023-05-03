# Описание выполненных заданий

## Настройка окружения виртуалок
- Создал и настроил 2 ВМ;
- Создал пару ключей;
- Данные IP виртуалок:
bastion_IP = 51.250.77.251
someinternalhost_IP = 10.128.0.23

## Настройка SSH для bastion сервера
- Подключился к bastion host через SSH используя ключи: `ssh-keygen -t rsa -f ~/.ssh/kek_user_ycloud -C kek_user_ycloud -P ""` и `ssh -i ~/.ssh/kek_user_ycloud kek_user_ycloud@51.250.77.251`.
- Настроил SSH форвандинг на someinternalhost.

## Использование Bastion host для сквозного подключения к someinternalhost
- Добавил приватный ключ удалённого хоста в кэш SSH-агента.
- Подключился к веб-серверу `ssh -i ~/.ssh/kek_user_ycloud -A kek_user_ycloud@51.250.77.251`.
- Подключился к удалённому серверу `ssh someinternaluser@10.128.0.23`.

## Самостоятельное задание №1
- Исследовал способ подключения к someinternalhost в одну команду из моего локального хоста. Проверил работоспособность найденного решения и внёс его в README.md в этой репе:
1. Добавляем приватный ключ bastion в кэш SSH-агента `ssh-add kek_user_ycloud`;
2. Используем опцию ProxyCommand в команде SSH `ssh -A -J kek_user_ycloud@51.250.77.251 someinternaluser@10.128.0.23`:
```
Пояснения:
- `-A` - включаем SSH Forwarding для передачи аутентификационных ключей;
- `-J` - используем Jump Host (промежуточный хост) для доступа к машине из внутренней сети;
- `user_keka_ycloud@51.250.77.251` - это удаленный хост (Jump Host), через который будет происходить SSH Forwarding и доступ к `someinternalhost`;
- `someinternaluser@10.128.0.29` - это целевой хост, к которому вы хотите подключиться.
```
## Дополнительное задание №1
- Предложил вариант решения для подключения из консоли при помощи команды вроде `ssh someinternalhost`. Внёс решение в README.md:
1. Добавляем приватный ключ bastion в кэш SSH-агента `ssh-add kek_user_ycloud`;
2. Чтобы подключаться к удаленной машине `someinternalhost` через алиас `someinternalhost`, нужно добавить запись в файл `~/.ssh/config` на нашем локальном устройстве;
3. Добавляем следующие строки:
```
Host someinternalhost
    HostName 10.128.0.23
    User someinternaluser
    ProxyCommand ssh -A kek_user_ycloud@51.250.77.251 -W %h:%p

Здесь:
- `Host someinternalhost` — это ваш алиас для `someinternalhost`, который будет использоваться при подключении;
- `HostName 10.128.0.29` — это IP-адрес машины `someinternalhost`;
- `User someinternaluser` — это имя пользователя, с которым хотим подключиться к машине `someinternalhost`;
- `ProxyCommand ssh -A user_keka_ycloud@51.250.77.251 -W %h:%p` — это команда, которая указывает, что мы хотим использовать `bastion` как промежуточный хост для подключения к `someinternalhost`.
```
Теперь можем подключаться к `someinternalhost` через алиас `someinternalhost`, используя команду `ssh someinternalhost` в терминале. SSH автоматически определит, что `someinternalhost` соответствует настройке в файле `~/.ssh/config` и выполнит подключение через промежуточный хост `bastion`.

## Создание и настройка VPN-сервера на PritUNL
- Создал и настроил VPN-сервер на PritUNL.

## Настройка подключения к VPN серверу как его пользователь (доступ к someinternalhost)
- В корне репы прикрепил конфиг пользователя.

## Дополнительное задание №2
- Задание со звёздочкой выполнил, используя доменное имя (попросил у приятеля из нашей группы :) ). Использовал его в настройках VPN PritUNL в настройках.
