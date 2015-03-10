# Money

Гем для работы с курсами валют.

## Установка

Добавьте следующую строку в Gemfile вашего приложения:

```ruby
gem 'money', git: 'https://github.com/OleOle7177/money'
```
Затем запустите bundle: 

    $ bundle install

Далее добавьте в свой проект миграции базы данных и модели ActiveRecord:

	$ rails g money:install 

Запустите миграции: 

	$ rake db:migrate

Гем готов к работе! 

## Использование 

Гем предоставляет следующий интерфейс для работы с курсами валют: 

1) Установить базовую валюту с кодом 'EUR' для кросс-конвертаций: 
```ruby
Money.set_base('EUR')
```
2) Узнать текущую базовую валюту: 
```ruby
Money.get_base
```
3) Для валюты с кодом 'USD' установить курс со значением 1.5 относительно базовой: 
```ruby
Money.set_currency(from: 'USD', rate: 1.5)
```
4) Узнать курс валюты с кодом 'USD' относительно базовой на текущий момент: 
```ruby
Money.get_currency(from: 'USD')
```
5) Узнать курс валюты с кодом 'USD' относительно базовой на момент 7 марта 2015 года 12:00:00:  
```ruby
Money.get_currency(from: 'USD', datetime: '2015-03-07 12:00:00')
```
6) Узнать курс валюты 'USD' относительно валюты 'EUR' на текущий момент: 
```ruby
Money.get_currency(from: 'USD', to: 'EUR')
```
7) Узнать курс валюты 'USD' относительно валюты 'EUR' на момент 7 марта 2015 года 12:00:00: 
```ruby
Money.get_currency(from: 'USD', to: 'EUR', datetime: '2015-03-07 12:00:00')
```
8) Получить значения курсов валют относительно рубля с сервиса Центробанка РФ (для валют, занесённых в базу данных): 

	$ rake getcbrates

9) Рассчитать значения курсов валют (на основе данных ЦБ РФ о курсах относительно рубля) относительно текущей базовой валюты: 
```ruby
Money.calculate
```


