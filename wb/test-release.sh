#!/bin/bash

# Определение IP-адресов для точек входа
ru=10.246.133.152
rubas=10.246.133.152
by=10.246.133.152
gl=10.246.133.152
ge=10.246.133.152

# Запуск Chrome с кастомными настройками
"/usr/bin/google-chrome-stable" \
--ignore-certificate-errors \
--user-data-dir=/home/lebedev.aleksey101/chrome-users/wildberries-test-release \
--host-resolver-rules="MAP www.wildberries.ru $ru, MAP ru-basket-api.wildberries.ru $rubas, MAP www.wildberries.by $by, MAP www.global.wildberries.ru $gl, MAP www.wildberries.ge $ge"
