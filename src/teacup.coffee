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

  raw: 'script style' 

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


class Teacup 
  constructor: ->
    @htmlOut = null
    
  resetBuffer: (html=null) -> 
    previous = @htmlOut
    @htmlOut = html
    return previous

  render: (template, args...) ->
    previous = @resetBuffer('')
    try
      template(args...)
    catch error
      throw @cleanStack error
    finally
      result = @resetBuffer previous
    return result

  # alias render for coffeecup compatibility
  cede: (args...) -> @render(args...)

  cleanStack: do ->
    lineExpressions = [
      '\\s*at Teacup\\.renderContents .*'
      '\\s*at Teacup\\.tag .*'
      '\\s*at Teacup.* \\[as (\\w+)\\].*'
      '\\s*at Teacup\\.tags\\.bound.*$'
    ]
    tagExpression = new RegExp "^#{lineExpressions.join '\\n'}", 'mg'

    (error) ->
      error.stack = error.stack?.replace tagExpression, '    at Teacup.$1'
      return error
  
  renderable: (template) ->
    teacup = @
    return (args...) ->
      if teacup.htmlOut is null
        teacup.htmlOut = ''
        try
          template.apply @, args
        catch error
          throw teacup.cleanStack error
        finally
          result = teacup.resetBuffer()
        return result
      else
        template.apply @, args

  renderAttr: (name, value) -> 
    if not value? or value is false
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
      delete obj[name]

    # then unordered attrs 
    for name, value of obj
      result += @renderAttr name, value

    return result

  renderContents: (contents) ->
    if not contents?
      return
    else if typeof contents is 'function'
      contents.call @
    else
      @text contents

  isSelector: (string) ->
    chars = string.split ''
    string.length > 1 and chars[0] in ['#', '.']  

  parseSelector: (selector) ->
    id = null
    classes = []
    for token in selector.split '.'
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
            selector = @parseSelector(arg)
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

    if selector?
      {id, classes} = selector
      attrs.id = id if id?
      attrs.class = classes.join(' ') if classes?.length

    return {attrs, contents}

  tag: (tagName, args...) ->
    {attrs, contents} = @normalizeArgs args
    @raw "<#{tagName}#{@renderAttrs attrs}>"
    @renderContents contents
    @raw "</#{tagName}>"

  rawTag: (tagName, args...) ->
    {attrs, contents} = @normalizeArgs args
    @raw "<#{tagName}#{@renderAttrs attrs}>"
    @raw contents
    @raw "</#{tagName}>"

  selfClosingTag: (tag, args...) ->
    {attrs, contents} = @normalizeArgs args
    if contents
      throw new Error "Teacup: <#{tag}/> must not have content.  Attempted to nest #{contents}"
    @raw "<#{tag}#{@renderAttrs attrs} />"

  coffeescript: (fn) ->
    @raw """<script type="text/javascript">(function() {
      var __slice = [].slice,
          __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; },
          __hasProp = {}.hasOwnProperty,
          __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };
      (#{fn.toString()})();
    })();</script>"""

  comment: (text) ->
    @raw "<!--#{@escape text}-->"

  doctype: (type=5) ->
    @raw doctypes[type]

  ie: (condition, contents) ->
    @raw "<!--[if #{@escape condition}]>"
    @renderContents contents
    @raw "<![endif]-->"

  text: (s) ->
    unless @htmlOut?
      throw new Error("Teacup: can't call a tag function outside a rendering context")
    @htmlOut += s? and @escape(s.toString()) or ''

  raw: (s) ->
    @htmlOut += s

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
  # Binding
  #
  tags: ->
    bound = {}

    boundMethodNames = [].concat(
      'cede coffeescript comment doctype escape ie raw render renderable script tag text'.split(' ')
      merge_elements 'regular', 'obsolete', 'raw', 'void', 'obsolete_void'
    )
    for method in boundMethodNames
      do (method) =>
        bound[method] = (args...) => @[method].apply @, args

    return bound

# Define tag functions on the prototype for pretty stack traces
for tagName in merge_elements 'regular', 'obsolete'
  do (tagName) ->
    Teacup::[tagName] = (args...) -> @tag tagName, args...

for tagName in merge_elements 'raw'
  do (tagName) ->
    Teacup::[tagName] = (args...) -> @rawTag tagName, args...

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
  
