![teacup](https://raw.github.com/goodeggs/teacup/master/docs/teacup.jpg)

Getting Started
---------------

### Install

    $ npm install teacup

### Render

``` coffee
{render, div, h1} = require 'teacup'

render ->
  div '#sample', ->
    h1 -> 'Hello, world'
```

### Express

Register Teacup as a view engine.

``` coffee
express = require 'express'
teacup = require 'teacup/lib/express'

app = express()
app.configure ->
  app.engine "coffee", teacup.renderFile
```

Then write your views as regular old coffee files that export a renderable template.

```coffee
# views/example.coffee
{renderable, div, h1} = require 'teacup'

module.exports = renderable ({title}) ->
  div '#example', ->
    h1 "Hello, #{title}"
```


You can use Teacup templates even if your Express app is not using CoffeeScript.

Legacy
-------

[Markaby](/markaby/markaby) begat [CoffeeKup](/mauricemach/coffeekup) begat [CoffeeCup](/gradus/coffeecup) and [DryKup](/mark-hahn/drykup) which begat **Teacup**.

Contributing
-------------

```
$ git clone https://github.com/goodeggs/teacup && cd teacup
$ npm install
$ npm test
```
