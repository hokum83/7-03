# Домашнее задание к занятию "`Подъём инфраструктуры в Yandex Cloud`" - `Гультяев Алексей`

---

### Задание 1,2,3

`Настроен подьем и настройка инфраструктуры в яндекс облаке:`
1. `плейбуки ansible для установки и запуска ПО запускаются из terraform`
2. `добавлено развертывание сервера СУБД`
3. `для обоих типов серверов (веб и СУБД) используется общая роль установки ПО и проверки работы сервиса, в плейбуке передаются переменные `
4. `через переменную можно задавать количество поднимаемых инстансов`
5. `настроена безопасная передача токена от облака в terraform через переменные окружения`

`Результат выполнения комманды` **```terraform apply```** `:`
![Скриншот-1](https://github.com/hokum83/7-03/blob/main/img/terraform_apply.png)

