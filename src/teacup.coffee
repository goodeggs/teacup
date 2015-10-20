log = console.log

doctypes =
  'default': '<!DOCTYPE html>'
  '5': '<!DOCTYPE html>'
  'xml': '<?xml version="1.0" encoding="utf-8" ?>'
  'transitional': '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
  'strict': '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'
  'frameset': '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">'
  '1.1': '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">'
  'basic': '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML Basic 1.1//EN" "http://www.w3.org/TR/xhtml-basic/xhtml-basic11.dtd">'
  'mobile': '<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">'
  'ce': '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "ce-html-1.0-transitional.dtd">'

elements =
  # Valid HTML 5 elements requiring a closing tag.
  # Note: the `var` element is out for obvious reasons, please use `tag 'var'`.
  regular: 'a abbr address article aside audio b bdi bdo blockquote body button
 canvas caption cite code colgroup datalist dd del details dfn div dl dt em
 fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6 head header hgroup
 html i iframe ins kbd label legend li map mark menu meter nav noscript object
 ol optgroup option output p pre progress q rp rt ruby s samp section
 select small span strong sub summary sup table tbody td textarea tfoot
 th thead time title tr u ul video'

  raw: 'style'

  script: 'script'

  # Valid self-closing HTML 5 elements.
  void: 'area base br col command embed hr img input keygen link meta param
 source track wbr'

  obsolete: 'applet acronym bgsound dir frameset noframes isindex listing
 nextid noembed plaintext rb strike xmp big blink center font marquee multicol
 nobr spacer tt'

  obsolete_void: 'basefont frame'

# Create a unique list of element names merging the desired groups.
merge_elements = (args...) ->
  result = []
  for a in args
    for element in elements[a].split ' '
      result.push element unless element in result
  result

# use queue for async rendering
# anywhere htmlOut is modified we need to queue the update
# opening tags go to htmlOut immediately
# contents run immediately and delay further action until it's done
# closing tags wait for contents to finish
class Queue

  constructor: (options) ->
    @debug = false
    @items = []
    @names = []
    @position = 0
    @running = false

  push: (name, fn) ->
    @names.splice @position, 0, name
    @items.splice @position, 0, fn
    log 'push', @position, name if @debug
    @print()
    @position++

  print: ->
    if @debug
      log JSON.stringify @names, null, 2
      log ''

  run: ->
    return if @running
    return @drain?() if @items.length == 0
    @running = true
    name = @names.shift()
    fn = @items.shift()
    @position--
    log 'run', name if @debug
    @print()
    fn =>
      @running = false
      @run()

class Teacup
  constructor: ->
    @htmlOut = null
    @queue = new Queue()

  resetBuffer: (html=null) ->
    previous = @htmlOut
    @htmlOut = html
    return previous

  render: (template, args...) ->
    if typeof args[args.length - 1] is 'function'
      callback = args.pop()

    previous = @resetBuffer('')
    if callback
      @renderContents template, args...
      @queue.drain = =>
        result = @resetBuffer previous
        callback result
      @queue.run()
    else
      try
        @renderContents template, args...
        @queue.drain = null
        @queue.run()
      catch err
        throw err
      finally
        result = @resetBuffer previous
      return result

  # alias render for coffeecup compatibility
  cede: (args...) -> @render(args...)

  renderable: (template) ->
    teacup = @
    return (args...) ->
      if teacup.htmlOut is null
        teacup.htmlOut = ''
        try
          template.apply @, args
          teacup.queue.drain = null
          teacup.queue.run()
        finally
          result = teacup.resetBuffer()
        return result
      else
        template.apply @, args

  renderAttr: (name, value) ->
    if not value?
      return " #{name}"

    if value is false
      return ''

    if name is 'data' and typeof value is 'object'
      return (@renderAttr "data-#{k}", v for k,v of value).join('')

    if value is true
      value = name

    return " #{name}=#{@quote @escape value.toString()}"

  attrOrder: ['id', 'class']
  renderAttrs: (obj) ->
    result = ''

    # render explicitly ordered attributes first
    for name in @attrOrder when name of obj
      result += @renderAttr name, obj[name]

    # then unordered attrs
    for name, value of obj
      continue if name in @attrOrder
      result += @renderAttr name, value

    return result

  # TODO: add back in component support
  renderContents: (contents, rest...) ->
    return if not contents?
    @queue.push "contents: #{contents}", (done) =>
      @queue.position = 0
      if typeof contents is 'function'
        if contents.length is 0
          result = contents.apply @
          @text result if typeof result is 'string'
          done()
        else if contents.length is 1
          contents.call @, ->
            done()
      else
        @text contents
        done()

  isSelector: (string) ->
    string.length > 1 and string.charAt(0) in ['#', '.']

  parseSelector: (selector) ->
    id = null
    classes = []
    for token in selector.split '.'
      token = token.trim()
      if id
        classes.push token
      else
        [klass, id] = token.split '#'
        classes.push token unless klass is ''
    return {id, classes}

  normalizeArgs: (args) ->
    attrs = {}
    selector = null
    contents = null

    for arg, index in args when arg?
      switch typeof arg
        when 'string'
          if index is 0 and @isSelector(arg)
            selector = arg
            parsedSelector = @parseSelector(arg)
          else
            contents = arg
        when 'function', 'number', 'boolean'
          contents = arg
        when 'object'
          if arg.constructor == Object
            attrs = arg
          else
            contents = arg
        else
          contents = arg

    if parsedSelector?
      {id, classes} = parsedSelector
      attrs.id = id if id?
      if classes?.length
        if attrs.class
          classes.push attrs.class
        attrs.class = classes.join(' ')

    return {attrs, contents, selector}

  tag: (tagName, args...) ->
    {attrs, contents} = @normalizeArgs args
    @queue.push "open tag: #{tagName}", (done) =>
      @queue.position = 2
      @raw "<#{tagName}#{@renderAttrs attrs}>"
      done()
    @queue.push "tag contents: #{tagName}", (done) =>
      @queue.position = 2
      @renderContents contents
      done()
    @queue.push "close tag: #{tagName}", (done) =>
      @queue.position = 2
      @raw "</#{tagName}>"
      done()

  rawTag: (tagName, args...) ->
    {attrs, contents} = @normalizeArgs args
    @queue.push "raw tag: #{tagName}", (done) =>
      @raw "<#{tagName}#{@renderAttrs attrs}>"
      @raw contents
      @raw "</#{tagName}>"
      done()

  scriptTag: (tagName, args...) ->
    {attrs, contents} = @normalizeArgs args
    @queue.push "script: #{tagName}", (done) =>
      @raw "<#{tagName}#{@renderAttrs attrs}>"
      @renderContents contents
      @raw "</#{tagName}>"
      done()

  selfClosingTag: (tag, args...) ->
    {attrs, contents} = @normalizeArgs args
    if contents
      throw new Error "Teacup: <#{tag}/> must not have content.  Attempted to nest #{contents}"
    @queue.push "self closing tag: #{tag}", (done) =>
      @raw "<#{tag}#{@renderAttrs attrs} />"
      done()

  coffeescript: (fn) ->
    @queue.push "coffeescript: #{fn}", (done) =>
      @raw """<script type="text/javascript">(function() {
        var __slice = [].slice,
            __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; },
            __hasProp = {}.hasOwnProperty,
            __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };
        (#{@escape fn.toString()})();
      })();</script>"""
      done()

  comment: (text) ->
    @queue.push "comment: #{text}", (done) =>
      @raw "<!--#{@escape text}-->"
      done()

  doctype: (type=5) ->
    @queue.push "doctype: #{type}", (done) =>
      @raw doctypes[type]
      done()

  ie: (condition, contents) ->
    @queue.push "ie: #{condition}", (done) =>
      @raw "<!--[if #{@escape condition}]>"
      @renderContents contents
      @raw "<![endif]-->"
      done()

  text: (s) ->
    unless @htmlOut?
      throw new Error("Teacup: can't call a tag function outside a rendering context")
    @queue.push "text: #{s}", (done) =>
      @htmlOut += s? and @escape(s.toString()) or ''
      done()
    null

  raw: (s) ->
    return unless s?
    @queue.push "raw: #{s}", (done) =>
      @htmlOut += s
      done()
    return null

  #
  # Filters
  # return strings instead of appending to buffer
  #

  # Don't escape single quote (') because we always quote attributes with double quote (")
  escape: (text) ->
    text.toString().replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')

  quote: (value) ->
    "\"#{value}\""

  #
  # Plugins
  #
  use: (plugin) ->
    plugin @

  #
  # Binding
  #
  tags: ->
    bound = {}

    boundMethodNames = [].concat(
      'cede coffeescript comment component doctype escape ie normalizeArgs raw render renderable script tag text use'.split(' ')
      merge_elements 'regular', 'obsolete', 'raw', 'void', 'obsolete_void'
    )
    for method in boundMethodNames
      do (method) =>
        bound[method] = (args...) => @[method].apply @, args

    return bound

  component: (func) ->
    (args...) =>
      {selector, attrs, contents} = @normalizeArgs(args)
      renderContents = (args...) =>
        args.unshift contents
        @renderContents.apply @, args
      func.apply @, [selector, attrs, renderContents]

# Define tag functions on the prototype for pretty stack traces
for tagName in merge_elements 'regular', 'obsolete'
  do (tagName) ->
    Teacup::[tagName] = (args...) -> @tag tagName, args...

for tagName in merge_elements 'raw'
  do (tagName) ->
    Teacup::[tagName] = (args...) -> @rawTag tagName, args...

for tagName in merge_elements 'script'
  do (tagName) ->
    Teacup::[tagName] = (args...) -> @scriptTag tagName, args...

for tagName in merge_elements 'void', 'obsolete_void'
  do (tagName) ->
    Teacup::[tagName] = (args...) -> @selfClosingTag tagName, args...

if module?.exports
  module.exports = new Teacup().tags()
  module.exports.Teacup = Teacup
else if typeof define is 'function' and define.amd
  define('teacup', [], -> new Teacup().tags())
else
  window.teacup = new Teacup().tags()
  window.teacup.Teacup = Teacup
