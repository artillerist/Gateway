# Поддержка lua скриптов

## Введение

Шлюз SLS самодостаточен и может обходиться без внешних систем управления Умным домом. Для реализации автоматизаций, он поддерживает скриптовый язык программирования [LUA](https://ru.wikipedia.org/wiki/Lua).
При разработке скриптов можно использовать функции как встроенные в прошивку шлюза, так и функции поддерживаемых шлюзом библиотек LUA.
Текущая, поддерживаемая, версия [LUA 5.4.4](https://www.lua.org/versions.html#5.4) (с версии прошивки 2022.01.30d1).

---

## Соглашения

Немного о форматировании и названиях различных объектов шлюза.

Для работы с различными объектами используется формат кода типа `zigbee.getStatus()`. В терминологии LUA это выглядит как `библиотека.функция()`. Поэтому постараемся придерживаться подобного именования объектов SLS.

Форматирование текста:

- пункты меню: *File -> Save*
- небольшие куски кода: `print(a)`
- многострочный код:

```lua
local var = 0
print(var)
```

Описание синтаксиса:

```lua
result = function(var1, var2[, var3])
-- Описание переменных, передаваемых в функцию и их тип
-- var1 - STR, переменная 1
-- var2 - INT, переменная 2
-- var3 - BOOL, переменная 3 (если в [квадратных] скобках, то передавать не обязательно)
-- описание результата
-- result - type, если функция что-то возвращает, описывается здесь
```

---
Примечания:

- draft - черновик или будет добавлено в будущем
- deprecated - будет удалено в будущем

---

## Асинхронное программирование

Немного о модели программирования для нашего шлюза. При проектировании алгоритмов лучше не использовать функции а-ля os.delay() и самописные аналоги, выполняющие паузы в работе сценария более 1 секунды. Вместо этого лучше проектировать вызовы кусков кода из разных скриптов.

Например, часто при включении света в техническом или проходном помещении, необходимо сделать паузу и свет выключить. Первое, что приходит в голову - это сделать паузу в теле текущего сценария. Но, правильнее передать управление другому скрипту или вызвать основной [рекурсивно](/lua_doc/luaMainDoorLight.md).  
Об асинхронности в программировании можно почитать, например [здесь](https://habr.com/ru/company/jugru/blog/446562).

---

## Примеры кода

Все примеры скриптов собраны [здесь](/samples_rus.md)

---

## Редактор скриптов и отладка

Редактор скриптов, по совместительству с файловым менеджером предназначен для создания, удаления и редактирования файлов, в том числе и скриптов.
Найти его можно в меню *Actions -> Files* (в старых версиях прошивки *Actions -> Scripts*).
![lua Script Editor](/img/luaScriptEditor.png)
Редактор разделен на несколько областей:

- Меню, с кнопками:
  - *Toggle files* - скрыть / отобразить панель файлов
  - *Save* - сохранить
  - *Run* - запустить скрипт на исполнение
  - *Clear output* - очистить панель вывода
- Панель *Files*. Позволяет управлять файлами:
  - Создать - *New file*
  - Удалить - значок корзины напротив имени каждого файла
  - Открыть на редактирование - каждый файл представляет собой ссылку, по которой файл открывается в панели редактора
- Панель редактора
- Панель вывода - консоль для вывода результатов работы редактируемого скрипта

Скриптовый `stdout` функции LUA `print()` выводит информацию на Панель вывода, а также в системный лог (меню *Log*) шлюза. Данную функцию удобно использовать для отладки.

Для разработки или отладки скрипта, необходимо создать новый файл или открыть существующий. Например, с именем `test.lua` и в него ввести код на языке LUA.

Отладка скриптов выполняется преимущественно в Редакторе скриптов SLS. Однако, некоторые пользовательские функции может быть удобнее разрабатывать во "взрослых" IDE. Например, нативный [ZeroBrain Studio](https://studio.zerobrane.com), VS Code, Atom и других.

---

## Запуск скриптов

В зависимости от задач, выполняемых той или иной автоматизацией, доступны несколько вариантов запуска скриптов:

1. [из скрипта инициализации](/lua_rus.md#скрипт-инициализации)
2. [при изменении состояния устройства](/lua_rus.md#запуск-скрипта-при-изменении-состояния-устройства)
3. [по событию изменения объекта](/lua_rus.md#запуск-скрипта-по-событию-изменения-объекта)
4. [запуск из другого скрипта](/lua_rus.md#запуск-lua-скрипта-из-другого-скрипта)
5. [с помощью  HTTP API](/http_api_rus.md#скрипты-lua)
6. [периодический запуск (Таймеры)](/timers_rus.md)
7. по подписке mqtt (в разработке).

### Скрипт инициализации

При запуске системы выполняется скрипт инициализации `init.lua`, если он есть. Перед началом работы со скриптами, рекомендуется проверить его наличие рядом со всеми остальными скриптами `*.lua`. Если файла нет, то его нужно в редакторе скриптов.  В `init.lua` полезно инициализировать переменные для работы с устройством, а также выполнить какие либо действия. [Например:](/samples_rus.md#скрипт-инициализации)

```lua
-- init.lua --
-- Уведомление в Telegram о старте шлюза --
telegram.settoken("51778***5:AAG0bvK***")
telegram.setchat("-3348***")
telegram.send("SLS загружен!!!")
```

---

### Запуск скрипта при изменении состояния устройства

Скрипт можно запускать как одно из правил [SimpleBind](/simplebind_rus.md).

Синтаксис: `scriptname.lua[,Param]`

Например, так может выглядеть запись SB Rule для датчика открытия ![SB Rule](/img/luaSBRule.png)

- `mainDoorOnLight.lua` - имя запускаемого скрипта
- `Param` - необязательный параметр, через который в скрипт можно передать необходимые аргументы. Принимается он в скрипте через Событие `Event.Param`
Аргументов может быть несколько. В данном примере передается 3 аргумента, разделенные символом `:`: целевое устройство, которым должен управлять датчик по сработке; контролируемый статус; задержка управляющего действия. Если аргументы не прописывать, то при изменении условий, придется менять эти значения в теле скрипта. Пример похожего скрипта [здесь](/lua_doc/luaMainDoorLight.md)

Также, в Simple Bind можно запускать текст скрипта:
![SB Rule Run Lua Code](/img/sbRuleRunLuaCode.png)

---

### Запуск скрипта по событию изменения объекта

Привязка к объекту скрипта: [obj.setScript()](/objects_rus.md#objsetscript)

---

### Запуск LUA скрипта из другого скрипта

#### dofile()

Выполняет текст скрипта в контексте текущего.

```lua
dofile(scriptPath)
-- scriptPath - STR, путь к запускаемому скрипту вида "/int/script.lua"
```

#### scripts.run()

```lua
scripts.run(script[, Param])
-- script - STR, имя файла скрипта, без расширения `lua`
-- Param - STR, аргументы, передаваемые в скрипт
```

---

## Библиотеки SLS

В прошивку шлюза встроены следующие библиотеки:

- [obj.](/objects_rus.md#lua) - работа с объектами
- [Event.](/lua_rus.md#Библиотека-event) - работа с событиями
- [zigbee.](/lua_rus.md#библиотека-zigbee) - управление zigbee устройствами
- [mqtt.](/lua_rus.md#библиотека-mqtt) - работа с MQTT брокером
- [http.](/lua_rus.md#библиотека-http) - взаимодействие с внешними системами по HTTP
- [telegram.](/lua_rus.md#библиотека-telegram) - отправка уведомлений и управление шлюзом. [Подробнее здесь](/telegram_rus.md)
- [os.](/lua_rus.md#Библиотека-os) - взаимодействие с операционной системой шлюза. [Работа с хранилищем](/storage_rus.md)
- [gpio.](/lua_rus.md#Библиотека-GPIO) - управление GPIO
- [audio.](/lua_rus.md#Библиотека-audio) - управление встроенным в шлюза звуком
- [net.](/lua_rus.md#Библиотека-net) - получение IP адресов шлюза
- [yeelight.](/lua_rus.md#Библиотека-yeelight) - управление устройствами Yeelight
- [cloud.](/lua_rus.md#Библиотека-cloud) - работа с облаком SLS `cloud.slsys.io`

[Примеры использования](/samples_rus.md).

### Библиотека EVENT

Библиотека `Event` служит для передачи данных в скрипт, в зависимости от того, из какой подсистемы он вызван.

### Типы событий

События различаются типом `Event.Type`. В скрипт передается числовое значение типа события, позволяющее определить источник вызова и получить различные параметры:

1. [Вызов по изменению состояния привязанного сенсора](/lua_rus.md#Вызов-из-SB-Rule). Правило Simple Bind. `SCRIPT_EVENT_TYPE_STATE_UPDATE`
2. [Вызов по изменению объекта](/objects_rus.md#lua). `SCRIPT_EVENT_TYPE_OBJ_CHANGE`
3. [Вызов по входящему сообщению Telegram](/telegram_rus.md) `SCRIPT_EVENT_TYPE_TLG_MESSAGE`
4. [Таймер однократный.](/lua_rus.md#Вызов-по-однократному-таймеру) `SCRIPT_EVENT_TYPE_TIMEOUT`
5. [Таймер периодический.](/lua_rus.md#Вызов-по-периодическому-таймеру) `SCRIPT_EVENT_TYPE_INTERVAL`
6. [Таймер Cron.](/lua_rus.md#Вызов-по-таймеру-Cron) `SCRIPT_EVENT_TYPE_CRON`
7. [Вызов из LUA командой scripts.run()](/lua_rus.md#scriptsrun) `SCRIPT_EVENT_TYPE_RUN`

### Свойства событий

Для всех типов событий передаются следующие свойства:

- `Event.Type` - тип события INT
- `Event.Name` - имя файла вызванного скрипта с расширением
- `Event.Time` - время вызова скрипта `table(sec, min, hour, day, wday, month, year)`.

#### Вызов из SB Rule

- `Event.Param` - аргументы
- `Event.nwkAddr` - nwkAddr вызывающего устройства
- `Event.ieeeAddr` - ieeeAddr вызывающего устройства
- `Event.ModelId` - ModelId вызывающего устройства
- `Event.FriendlyName` - FriendlyName вызывающего устройства
- `Event.State.Name` - имя вызывающего "состояния"
- `Event.State.Value` - текущее значение "состояния"
- `Event.State.OldValue` - предыдущее значение "состояния"

#### Вызов по однократному таймеру

- `Event.Param` - аргументы

#### Вызов по периодическому таймеру

- `Event.Param` - аргументы

#### Вызов по таймеру Cron

- `Event.Param` - аргументы

<!-- TODO Продолжить с возвращаемыми значениями -->

---

### Библиотека ZIGBEE

Служит для управления zigbee устройствами, зарегистрированными на шлюзе. Подробные примеры [здесь](/samples_rus.md#zigbee)

#### zigbee.getStatus()

Возвращает статус координатора. Если запущен, вернёт 9.
Начиная с версии 2022.07.24d1.

```lua
coord_status = zigbee.getStatus()
-- coord_status - INT, статус zigbee координатора. 9 - OK
```

#### zigbee.join()

Включает режим сопряжения для подключения новых устройств

```lua
zigbee.join(duration = 255[, router])
-- duration - INT, время в секундах, на которое включить Join
-- router - STR, FriendlyName, ieeeAddr или nwkAddr устройства - роутера. Если опустить этот параметр, сопряжение будет открыто для всей сети
```

#### zigbee.value()

Возвращает значения состояния устройства из кэша

```lua
result = zigbee.value(device, state)
-- device - STR, FriendlyName, ieeeAddr или nwkAddr устройства
-- state - STR, состояние, значение которого необходимо получить
-- result - значение состояния
```

#### zigbee.get()

Вызывает функцию GET в конвертере. Возвращает `true` в случае успеха.

```lua
result = zigbee.get(device, state)
-- device - STR, FriendlyName, ieeeAddr или nwkAddr устройства
-- state - STR, состояние, значение которого необходимо получить
-- result - BOOL, true - успех, false - вероятно в конвертере нет команды GET 
```

#### zigbee.set()

Устанавливает значение состояния устройства

```lua
result = zigbee.set(device, stateName, stateValue)
-- device - STR, FriendlyName, ieeeAddr или nwkAddr устройства
-- stateName - STR, имя состояния, значение которого необходимо изменить
-- stateValue - значение состояние. Тип - свой для каждого значения. Например, для кнопки State:Action тип будет STR, а для яркости State:brightness тип будет INT 
-- result - NIL - устройство не найдено, BOOL, true - успех, false - ошибка в имени состояния и/или его значении
```

#### zigbee.setState()

Устанавливает значение состояния устройства. Можно указать тип значения (по умолчанию STR) и необходимо ли выполнять события (с версии 2022.07.24d1, по умолчанию true) .
В отличие от `zigbee.set()` позволяет создавать свои состояния, виртуальные. [Например](/samples_rus.md#Преобразование-показателей-давления-из-kPa-в-mmhg), для хранения данных какого-либо состояния, в альтернативных единицах измерения.

```lua
result = zigbee.setState(device, stateName, stateValue[[, type], events])
-- device - STR, FriendlyName, ieeeAddr или nwkAddr устройства
-- stateName - STR, имя состояния, значение которого необходимо изменить
-- stateValue - значение состояние
-- type - STR, тип значений состояния
-- events - BOOL, выполнять события (по умолчанию true)
-- result - BOOL,  true - успех, false - устройство не найдено
```

#### zigbee.setModel()

Программное переназначение типа устройства.

```lua
zigbee.setModel(device, ModelId)
-- device - STR, FriendlyName, ieeeAddr или nwkAddr устройства
-- ModelId - STR, ModelId устройства, которое поддерживается шлюзом.
```

В некоторых случаях протокол взаимодействия новых устройств совпадает с теми, что уже поддерживаются шлюзом SLS. В таком случае можно при загрузке шлюза подменять идентификаторы, добавив в init.lua код:

```lua
zigbee.setModel("xBox", "ptvo.switch")
```

**Данный функционал будет полезен пользователям генератора прошивок ptvo, кто самостоятельно изменит имя устройства на кастомное.**

#### zigbee.readAttr() - draft

Отправляет запрос на чтение атрибута в кластере.

```lua
zigbee.readAttr(device, epId, clusterId, AttrId[, manufId])
-- device - STR, FriendlyName, ieeeAddr или nwkAddr устройства
-- epID - INT, номер эндпоинта
-- clusterID - INT, номер кластера
-- AttrId - INT, номер атрибута
-- Например, вернуть атрибут swBuild в кластере genBasic в 1 эндпоинте:
zigbee.readAttr("0x90FD9FFFFEF7E26D", 1, 0x4000, 0x0000)
```

#### zigbee.writeAttr() - draft

Записывает значение атрибута в кластере.

```lua
zigbee.writeAttr(device, epId, clusterId, AttrId, dataType, value[, manufId])
-- device - STR, FriendlyName, ieeeAddr или nwkAddr устройства
-- epID - INT, номер эндпоинта
-- clusterID - INT, номер кластера
-- AttrId - INT, номер атрибута
-- dataType - STR, тип данных
-- value - значение атрибута
```

#### zigbee.configReport() - draft

Конфигурирует репортинг атрибута в кластере.

```lua
zigbee.configReport(device, epId, clusterId, AttrId, dataType, minRepInt, maxRepInt, repChange)
-- device - STR, FriendlyName, ieeeAddr или nwkAddr устройства
-- epID - NUM, номер эндпоинта
-- clusterID - NUM, номер кластера
-- AttrId - NUM, номер атрибута
-- dataType - STR, тип данных
-- minRepInt - INT,
-- maxRepInt - INT,
-- repChange - BOOL,
```

---

### Библиотека MQTT

#### mqtt.pub()

Публикует на MQTT сервер в топик *topic* значение *payload*.

```lua
mqtt.pub(topic, payload)
```

Пример управления реле на прошивке Tasmota - `cmnd/имя устройства/имя реле`

```lua
mqtt.pub('cmnd/sonoff5/power', 'toggle')
```

#### mqtt.connected()

Возвращает статус подключение к брокеру MQTT. Выполняется без параметров.

#### mqtt.sub()

Подписывается на топик и помещает полученные значения в объект. Можно вызывать повторно с другим именем объекта, для его изменения.

```lua
mqtt.sub(topic, objName)
-- topic - STR, топик MQTT
-- objName - STR, объект, в который записываются данные
```

Пример подписки на топик с температурой, которую шлюз помещает в объект:

```lua
mqtt.sub('dev/sensor/temp', 'room_temp')
```

#### mqtt.unSub()

Отписывается от топика.

```lua
mqtt.unSub(topic)
```

Пример отписки от топика с температурой

```lua
mqtt.unSub('dev/sensor/temp')
```

---

### Библиотека HTTP

#### http.request2()

Служит для отправки HTTP (HTTPS в разработке) запросов во внешние системы. Поддерживает методы GET и POST.

```lua
http.request2 (url[:port], [method, headers, body])
-- url:port - STR, URL адрес и порт целевого ресурса
-- method - STR, метод POST или GET
-- headers - STR, заголовки запроса
-- body - STR, тело запроса
```

[Примеры](/samples_rus.md#HTTP-запросы)

#### http.request() - deprecated

---

### Библиотека TELEGRAM

[Подробное описание здесь](/telegram_rus.md)

#### telegram.settoken()

Инициализирует токен

```lua
telegram.settoken(token)
-- token - STR, API-токен вашего бота
```

#### telegram.setchat()

Инициализирует чат, в который бот будет отправлять уведомления

```lua
telegram.setchat(chatid)
-- chatid - STR, ID чата, куда бот будет писать сообщения
```

#### telegram.secure()

Инициализирует протокол HTTPS.
**Внимание! Включение этой опции отнимает большое количество свободной памяти! Возможны частые перезагрузки  шлюза!**

```lua
telegram.secure(enable)
-- enable - BOOL, включить: true, выключить (по-умолчанию): false
```

#### telegram.receive()

Инициализирует обработку входящих сообщений

```lua
telegram.receive(enable)
-- enable - BOOL, включить: true, выключить (по-умолчанию): false
```

#### telegram.send()

Отправляет сообщение.

```lua
telegram.send(msg[, chatid, parse_mode])
-- msg - STR, сообщение 
-- chatid - STR, ID чата, куда бот будет писать сообщения
-- parse_mode - STR, можно использовать для отправки ReplyKeyboard
```

---

### Библиотека OS

[Примеры](/samples_rus.md#Библиотека-OS)

#### os.time()

Возвращает Unix время. Вызывается без параметров.

#### os.sunrise([offset])

Возвращает время восхода солнца (часы, минуты). Для правильной работы требуется выполнить настройки *Settings -> Time & Location*

```lua
os.sunrise([offset])
-- offset - INT, позволяет добавить смещение в минутах к результату вывода
-- Пример:
sunriseH, sunriseM = os.sunrise()
print("Восход солнца в " .. sunriseH .. ":" .. sunriseM )
-->  Восход солнца в 10:55
```

#### os.sunset([offset])

Возвращает время заката солнца (часы, минуты). Для правильной работы требуется выполнить настройки *Settings -> Time & Location*

```lua
os.sunset([offset])
-- offset - INT, позволяет добавить смещение в минутах к результату вывода
```

#### os.setSleep()

Включает и выключает режим сна для модема WiFi. По-умолчанию выключено. Также можно заставить систему заснуть глубоким сном на `time` секунд, тем самым снизив энергопотребление практически до нуля. В этом режиме не работает ничего, кроме таймера отсчета до окончания сна, по прошествии которого система перезагрузится. Это может использоваться при питании от аккумулятора.

```lua
os.setSleep(enable[,time])
-- enable - BOOL, включить = true, выключить = false спящий режим
-- time - INT, время сна в сек.
```

#### os.delay()

Выполняет паузу выполнения скрипта на указанное время. Не рекомендуется делать паузу более чем на 1 секунду.

```lua
os.delay(time)
-- time - INT, время паузы в милисекундах (1 сек = 1000 мс)
```

#### os.millis()

Возвращает количество миллисекунд с момента загрузки системы. Вызывается без параметров.

#### os.getUptime()

Возвращает время с момента загрузки системы. Вызывается без параметров.

Пример:

```lua
print('Uptime: ' .. os.getUptime())
--> Uptime: 11 days 17:43:03
```

#### os.ntp()

Возвращает статус подключение к серверу времени (NTP): `true` - синхронизация с сервером NTP выполнена успешно. Вызывается без параметров.

#### os.freeMem()

Возвращает количество свободной памяти в байтах.

```lua
os.freeMem([type])
-- type - STR, heap, psram
-- без параметров возвращает объем FreeHeap
```

#### os.save()

Сохраняет данные. Тоже, что и меню *Actions -> Save*. Вызывается без параметров.

#### os.restart()

Перезагружает ОС. Вызывается без параметров.

#### os.ping()

Отправляет запросы ICMP PING на тестируемый хост. Возвращает среднее время ответа или -1 при недоступности.

```lua
os.ping(host[, count])
-- host - STR, IP или DNS адрес хоста
-- count - INT, количество запрсов (по-умолчанию 1)
```

#### os.wdt()

Включается и выключает WDT (Сторожевой таймер), может использоваться для отладки незапланированных перезагрузок.

```lua
os.wdt(enable)
-- enable - BOOL, включить (true), выключить (false) 
```

#### os.udplogenable()

Включает логирование через UDP. [Примеры получения лога](/faq_rus.md#включение-udp-log)

```lua
os.udplogenable(enable)
-- enable - BOOL, включить UDP лог (true); выключить (false)
```

#### os.setAssets()

Задает место хранения ресурсов web-интерфейса, для размещения на альтернативном web-сервере, например локальном. В разработке хранение web-ресурсов в хранилище SLS, для систем без выхода в интернет.

```lua
os.setAssets(url)
-- url - STR, источник ресурсов
```

#### os.led()

```lua
os.led(mode, brightness, r, g, b[, effect])
-- mode - STR, режим. OFF - выключено, ON - включено, AUTO - индикация режимов/состояний шлюза (см. описаниее далее) 
-- brightness - INT, яркость (целое, от 0 до 255)
-- r, g, b - INT, цвет (целое, от 0 до 255 или -1, если цвет менять не требуется)
-- effect - INT, включает эффекты в соответствии с таблицей
```

Подробнее о работе с LED [здесь](/led_control_rus.md)

#### os. функции для работы с хранилищем

Описание функций для работы с хранилищем [здесь](/storage_rus.md#скрипты-lua)

---

### Библиотека GPIO

Управление контактами ввода/вывода (GPIO) чипа ESP32.

#### gpio.mode()

Управление режимом контакта:

- gpio.INPUT: ввод
- gpio.OUTPUT: вывод
- gpio.INPUT_PULLUP: подтянуть к VCC
- gpio.INPUT_PULLDOWN: подтянуть к GND

```lua
gpio.mode(pin, mode)
-- pin: номер контакта
-- mode: режим контакта - gpio.INPUT, gpio.INPUT_PULLUP, gpio.INPUT_PULLDOWN, gpio.OUTPUT
```

#### gpio.read()

Чтение сигнала с GPIO

```lua
gpio.read(pin[, ADC)
-- pin: номер контакта
-- ADC: true - чтение ADC; false - чтение цифрового сигнала
```

Задать каналу 2 режим входа, получить его значение:

```lua
gpio.mode(25, gpio.INPUT)
local value = gpio.read(25)
print(value)
```

#### gpio.write()

Запись уровня в GPIO

```lua
gpio.write(pin, level)
-- pin: номер контакта
-- level: уровень - gpio.HIGH - высокий, gpio.LOW - низкий
```

Например, задать каналу 4 режим выхода и включить его на 100мс:

```lua
gpio.mode(27, gpio.OUTPUT)
gpio.write(27, 1)
os.delay(100)
gpio.write(27, 0)
```

### PWM (ШИМ)

ШИМ-контроллер ESP32 имеет 16 независимых каналов, которые можно настроить для генерации ШИМ-сигналов с различными свойствами. Все выводы, которые могут выступать в качестве выходов, могут использоваться в качестве выводов ШИМ (GPIO с 34 по 39 не могут генерировать ШИМ).

#### gpio.pwmSetup()

Настройка ШИМ

```lua
gpio.pwmSetup(channel, pin[, freq = 5000[, resolution = 8]])
-- chanel: канал ШИМ - 0-15
-- pin: номер контакта
-- resolution: разрешение 1-16 bits
-- freq: частота
```

#### gpio.pwm()

Управление ШИМ

```lua
gpio.pwm(channel, value)
-- channel: канал 0-15
-- value: значение ШИМ
```

Например, задать каналу 1 режим выхода и включить ШИМ со скважностью 50%

```lua
gpio.pwmSetup(3, 32)
gpio.pwm(3, 255/100*50)
```

---

### Библиотека AUDIO

Управление звуком

```lua
audio.playurl(url) -- проигрывание звука из URL
audio.geturl() -- возвращает текущий URL
audio.stop() -- остановить проигрывание
audio.setvolume(volume_percent) -- установить уровень громкости
audio.getvolume() -- возвращает текущий уровень громкости
audio.getstatus() -- возвращает текущий статус
```

---

### Библиотека NET

#### net.localIP()

Возвращает адрес устройства SLS в локальной сети. Выполняется без параметров.

#### net.remoteIP()  

Возвращает внешний адрес SLS в сети интернет (если доступен). Выполняется без параметров.

---

### Библиотека Yeelight

[Примеры](/samples_rus.md#библиотека-yeelight)

#### yeelight.send()

Управляет устройством Yeelight. [Описание протокола](https://www.yeelight.com/download/Yeelight_Inter-Operation_Spec.pdf). 

```lua
result = yeelight.send(id, method, param)
-- id - STR, IP адрес устройства
-- method - STR, команда
-- param - STR, параметры команды
-- result - JSON строка, согласно описания протокола
```

---

### Библиотека Cloud

#### cloud.isConnected()

Возвращает статус подключения к облаку SLS `cloud.slsys.io`

```lua
result = cloud.isConnected()
-- result - BOOL, true шлюз подключен к облаку SLS
```

---

## Функции LUA SLS

Функции LUA, встроенные в прошивку SLS, которые не объединены той или иной библиотекой.

### explode()

Разбивает строку с помощью разделителя. Результат помещает в таблицу.

```lua
explode(separator, string)
-- string - STR, строка, которую необходимо разбить
-- separator - STR, символ разделителя
-- пример:
local string = "param1|param2|param3"
local t = explode("|", string)
local param1 = t[1]
local param2 = t[2]
local param3 = t[3]
```

---

## Обработка нажатий аппаратной кнопки шлюза

Многие ревизии шлюзов имеют кнопку, нажатия которой можно обрабатывать скриптами. Например, для включения "режима сопряжения" при нажатии на боковую кнопку  шлюза
Необходимо привязать скрипт `btn_sw1.lua`

```lua
zigbee.join(255, "0x0000")
```

и привязать его выполнение в init.lua

```lua
obj.setScript("io.input0.value", "btn_sw1.lua")
```

- где `io.input0.value` - номер обрататываемого порта (в примере указана кнопка для круглого шлюза)

Более подробно вопрос с обрабокой событий gpio разобран в разделе [Модуля ввода-вывода](/devices/din_mini_io_rus.md)

---

## Полезные ссылки

1) [Примеры типовых сценариев](/samples_rus.md)
2) On-line учебник по [lua](https://zserge.wordpress.com/2012/02/23/lua-%D0%B7%D0%B0-60-%D0%BC%D0%B8%D0%BD%D1%83%D1%82/)
3) Генератор lua скриптов  на основе [Blockly](https://blockly-demo.appspot.com/static/demos/code/index.html)
