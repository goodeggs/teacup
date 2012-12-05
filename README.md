![teacup](https://raw.github.com/goodeggs/teacup/master/docs/teacup.jpg)

Teacup is templates in CoffeeScript.

One of the great things about CoffeeScript is it's ability to support native DSLs. Teacup is a native CoffeeScript DSL for producing HTML. Use composition and functional constructs, import helpers just as you would any other dependency.

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


Examples
---------

### Rendering

Use the `render` helper to render a template immediately.

```coffee
{render, ul, li} = require 'teacup'

output = render ->
  ul ->
    li 'First Item'
    li 'Second Item'

console.log output
# Outputs <ul><li>First Item</li><li>Second Item</li></ul>
```

Use the `renderable` helper to create a function that can be called to render the template at a later time.

```coffee
{renderable, ul, li} = require 'teacup'

template = renderable (items)->
  ul ->
    li item for item in items

console.log template(['One', 'Two'])
# Outputs <ul><li>One</li><li>Two</li></ul>
```

### Escaping

Teacup escapes input by default. To disable escaping, use the `raw` helper.

```coffee
{render, raw, h1, div} = require 'teacup'

inner = render ->
  h1 'Header'

console.log render ->
  div inner
# Outputs <div>&lt;h1&gt;Header&lt;/h1&gt;</div>

console.log render ->
  div ->
    raw inner
# Outputs <div><h1>Header</h1></div>
```

### Helpers

Write your view helpers as renderable functions and require them as needed.

Here's a helpers file that defines a set of [microformats](http://microformats.org/wiki/hcalendar).

```coffee
# views/microformats.coffee
{renderable, span, text} = require 'teacup'
moment = require 'moment'

module.exports =
  hcalendar: renderable ({date, location, summary}) ->
    span ".vevent", ->
      span ".summary", summary
      text " on "
      span ".dtstart", moment(date).format("YYYY-MM-DD")
      text " was in "
      span ".location", location
```

And a view that uses one of the helpers.

```coffee
# views/events.coffee
{renderable, ul, li} = require 'teacup'
{hcalendar} = require './microformats'

module.exports = renderable ({events}) ->
  ul ->
    for event in events
      li ->
        hcalendar event
```

### Compiling Templates

Just use the CoffeeScript compiler.

```
$ coffee -cl -o build src
```

FAQ
----

**How's this different from CoffeeCup?**

[CoffeeCup](/gradus/coffeecup) is the currently maintained fork of [CoffeeKup](/mauricemach/coffeekup) and is what we were using at Good Eggs before switching to Teacup. The problem with CoffeeCup is that it uses some `eval` magic to put the tag functions in scope. This magic breaks closure scope so you can't actually write templates using the functional constructs that you'd expect.

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
