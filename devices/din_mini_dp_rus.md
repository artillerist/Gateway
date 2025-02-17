# Модуль управления координатным домофоном
Устройство подключается в разрыв линии между домофоном и трубкой.

Выполняет функции:
* Детекция входящего вызова
* Ответ на входящий вызов
* Завершение вызова
* Открытие двери

Так же модуль содержит в себе два входа тип сухой контакт (Срабатывает при замыкании входа на GND)

## Работа без абонентской трубки
Устройство может работать без подключения трубки, для этого необходио установить джампер J1

## Назначение клемников
1: Вход 1

2: Вход 2

3: Линия (-)

4: Линия (+)

5: Трубка (-)

6: Трубка (+)

## Распределение GPIO
* Вход 1: GPIO32
* Вход 2: GPIO25
* Вход детектора звонка: GPIO26
* Выход Реле ответа на входящий звонок: GPIO27
* Выход Реле открытия двери : GPIO12
* Выход Зуммер: GPIO13

## Выбор программного режима работы порта
Выбор программного режима работы порта осуществляется через функции *gpio.mode(GPIO, mode)*, где mode может быть *gpio.INPUT* или *gpio.OUTPUT*.

Определение режима удобно прописать в файл *init.lua*, т.к. это требуется только однократно.

## Инициализация модуля
Для этого достаточно добавить в *init.lua* команду *dp.begin()*
После этого, при входящем звонке будет вызывать скрипт *dp.lua*

## Тайминги
Для разных домофонов необходимы разные тайминги, по умолчанию они такие:
1. DP_TIMING_CALL_TIMEOUT   = 3*1000
2. DP_TIMING_ANSWER_TIMEOUT = 60*1000
3. DP_TIMING_OPEN_TIMEOUT   = 1000
4. DP_TIMING_BEFORE_ANSWER  = 400
5. DP_TIMING_BEFORE_OPEN    = 1000

### Примеры использования
Ответить на звонок и открыть дверь:
```lua
dp.answer()
dp.open()
```

Сбросить вызов:
```lua
dp.answer()
dp.hangup()
```

Проверить, что сейчас идет вызов:
```lua
if dp.status() == dp.CALL begin
  print("CALL!")
end
```

Добавить входы модуля в объекты:
```lua
gpio.addInput(32, gpio.INPUT_PULLUP, 2, "IN1")
gpio.addInput(25, gpio.INPUT_PULLUP, 2, "IN2")
```

Установить таймаут открытия, для автозавершения в 2000мс:
```lua
dp.setTiming(3, 2000)
```




