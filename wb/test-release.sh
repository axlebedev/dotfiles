#!/bin/bash

ip=10.52.169.149
# Определение IP-адресов для точек входа
ru=$ip
rubas=$ip
by=$ip
gl=$ip
ge=$ip
et=$ip

# Запуск Chrome с кастомными настройками
"/usr/bin/google-chrome-stable" \
--ignore-certificate-errors \
--user-data-dir=/home/lebedev.aleksey101/chrome-users/wildberries-test-release \
--disable-web-security \
--ignore-certificate-errors \
--host-resolver-rules="MAP www.wildberries.ru $ru, MAP ru-basket-api.wildberries.ru $rubas, MAP www.wildberries.by $by, MAP www.global.wildberries.ru $gl, MAP www.wildberries.ge $ge, MAP www.wildberries.et $et"
