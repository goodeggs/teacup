![teacup](https://raw.github.com/goodeggs/teacup/master/docs/teacup.jpg)

Teacup is templates in CoffeeScript.

One of the great things about CoffeeScript is it's ability to support native DSLs. Teacup is a native CoffeeScript DSL for producing HTML. Use composition and functional constructs, import helpers just as you would any other dependency.

[![Build Status](https://travis-ci.org/goodeggs/teacup.png)](https://travis-ci.org/goodeggs/teacup)

Getting Started
---------------

### Install

To use in Node, either for templates rendered on the server or for templates compiled with
[connect-assets](https://github.com/TrevorBurnham/connect-assets):

    $ npm install teacup

If you're interested in using Teacup with Rails, [Teacup::Rails](https://github.com/goodeggs/teacup-rails) makes Teacup
available to the asset pipeline in Rails 3.1+.

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

### connect-assets

If you are using [connect-assets](https://github.com/TrevorBurnham/connect-assets) to compile your CoffeeScript in
an asset pipeline. You can use the Teacup middleware which registers the connect-assets `js` and `css` helpers with Teacup.

```coffee
express = require 'express'
connectAssets = require 'teacup/lib/connect-assets'
app = express()
app.configure ->
  app.use connectAssets(src: 'assets', jsDir: 'javascripts', cssDir: 'stylesheets')
```

And in your templates:

```coffee
{renderable, js, css, html, head, body} = require 'teacup'

module.exports = renderable ->
  html ->
    head ->
      js 'app'
      css 'app'
    body ->
      # ...
```

The Teacup middleware passes the provided options to connect-assets and returns an instance of the connect-assets middleware.

### Browser

To use for client-side rendering, all you need is [teacup.js](https://raw.github.com/goodeggs/teacup/master/lib/teacup.js)
from this project. Since Teacup is all about CoffeeScript, it only makes sense to use if you are writing your
views in CoffeeScript. Use it with an asset pipeline like in Rails or connect-assets (see above) or compile your templates
as part of your build process.

In the browser, Teacup exports window.teacup. In the examples below, simply replace `require 'teacup'` with `teacup`.

```coffee
{renderable, ul, li} = teacup

template = renderable (items)->
  ul ->
    li item for item in items

console.log template(['One', 'Two'])
```

### Backbone

You can write your template in the same file a Backbone View and call your template from the view's `render` method like so:
```coffee
{renderable, div, h1, ul, li, p, form, input} = teacup

template = renderable ({kids}) ->
  div ->
    h1 "Welcome to our tea party"
    p "We have a few kids at the table..."
    ul ->
      kids.each (kid) ->
        li kid.get 'name'
    form ->
      input placeholder: 'Add another'

class PartyView extends Backbone.View

  constructor: ({kids}) ->
    @kids = new Backbone.Collection kids
    super()

  render: ->
    @$el.html template({@kids})
    @$('form input').focus()
    @
    
```
Check out [teacup-backbone-example](https://github.com/goodeggs/teacup-backbone-example) for a complete Backbone + Express app.

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

[CoffeeCup](http://github.com/gradus/coffeecup) is the currently maintained fork of
[CoffeeKup](http://github.com/mauricemach/coffeekup) and is what we were using at Good Eggs before switching to Teacup.
The problem with CoffeeCup is that it uses some `eval` magic to put the tag functions in scope. This magic breaks
closure scope so you can't actually write templates using the functional constructs that you'd expect.

Legacy
-------

[Markaby](http://github.com/markaby/markaby) begat [CoffeeKup](http://github.com/mauricemach/coffeekup) begat
[CoffeeCup](http://github.com/gradus/coffeecup) and [DryKup](http://github.com/mark-hahn/drykup) which begat **Teacup**.

Contributing
-------------

```
$ git clone https://github.com/goodeggs/teacup && cd teacup
$ npm install
$ npm test
```
