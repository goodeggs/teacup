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
 th thead time title tr u ul video ngChange ngForm ngInclude ngPluralize ngView'

  raw: 'script style'

  # Valid self-closing HTML 5 elements.
  void: 'area base br col command embed hr img input keygen link meta param
 source track wbr'

  obsolete: 'applet acronym bgsound dir frameset noframes isindex listing
 nextid noembed plaintext rb strike xmp big blink center font marquee multicol
 nobr spacer tt'

  obsoleteVoid: 'basefont frame'

# Create a unique list of element names merging the desired groups.
mergeElements = (args...) ->
  result = []
  for a in args
    for element in elements[a].split ' '
      result.push element unless element in result
  result

hyphens = (s) -> s.replace(/([a-z\d])([A-Z])/g, '$1-$2').toLowerCase()

class Teacup
  constructor: ->
    @_htmlOut = null

  _resetBuffer: (html=null) ->
    previous = @_htmlOut
    @_htmlOut = html
    return previous

  render: (template, args...) ->
    previous = @_resetBuffer('')
    try
      template(args...)
    finally
      result = @_resetBuffer previous
    return result

  # alias render for coffeecup compatibility
  cede: (args...) -> @render(args...)

  renderable: (template) ->
    self = @
    return (args...) ->
      if self._htmlOut is null
        self._htmlOut = ''
        try
          template.apply @, args
        finally
          result = self._resetBuffer()
        return result
      else
        template.apply @, args

  _renderAttr: (name, value) ->
    name = hyphens(name)
    if not value?
      return " #{name}"

    if value is false
      return ''

    if name is 'data' and typeof value is 'object'
      return (@_renderAttr "data-#{k}", v for k,v of value).join('')

    if value is true
      value = name

    return " #{name}=#{@quote @escape value.toString()}"

  _attrOrder: ['id', 'class']
  _renderAttrs: (obj) ->
    result = ''

    # render explicitly ordered attributes first
    for name in @_attrOrder when name of obj
      result += @_renderAttr name, obj[name]
      delete obj[name]

    # then unordered attrs
    for name, value of obj
      result += @_renderAttr name, value

    return result

  _renderContents: (contents) ->
    if not contents?
      return
    else if Array.isArray(contents)
      @_renderContents(c) for c in contents
    else if typeof contents is 'function'
      contents.call @
    else
      @text contents

  _isSelector: (string) ->
    string.length > 1 and string[0] in ['#', '.']

  _parseSelector: (selector) ->
    id = null
    classes = []
    for token in selector.split '.'
      if id
        classes.push token
      else
        [klass, id] = token.split '#'
        classes.push token unless klass is ''
    return {id, classes}

  _normalizeArgs: (args) ->
    attrs = {}
    selector = null
    contents = []
    for arg, index in args when arg?
      switch typeof arg
        when 'string'
          if index is 0 and @_isSelector(arg)
            selector = @_parseSelector(arg)
          else
            contents.push(arg)
        when 'function', 'number', 'boolean'
          contents.push(arg)
        when 'object'
          if arg.constructor == Object
            attrs = arg
          else
            contents.push(arg)
        else
          contents.push(arg)

    if selector?
      {id, classes} = selector
      attrs.id = id if id?
      attrs.class = classes.join(' ') if classes?.length

    return {attrs, contents}

  tag: (tagName, args...) ->
    tagName = hyphens(tagName)
    {attrs, contents} = @_normalizeArgs args
    @raw "<#{tagName}#{@_renderAttrs attrs}>"
    @_renderContents contents
    @raw "</#{tagName}>"

  rawTag: (tagName, args...) ->
    tagName = hyphens(tagName)
    {attrs, contents} = @_normalizeArgs args
    @raw "<#{tagName}#{@_renderAttrs attrs}>"
    @raw contents
    @raw "</#{tagName}>"

  selfClosingTag: (tagName, args...) ->
    tagName = hyphens(tagName)
    {attrs, contents} = @_normalizeArgs args
    if contents.length
      throw new Error "Teacup: <#{tagName}/> must not have content.  Attempted to nest #{contents}"
    @raw "<#{tagName}#{@_renderAttrs attrs} />"

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
    @_renderContents contents
    @raw "<![endif]-->"

  text: (s) ->
    unless @_htmlOut?
      throw new Error("Teacup: can't call a tag function outside a rendering context")
    @_htmlOut += s? and @escape(s.toString()) or ''

  raw: (s) ->
    @_htmlOut += s

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

# Binding

teacup = new Teacup
bound = {}
bind = (tags, refer) ->
  for tag in tags
    do (tag, refer) ->
      Teacup::[tag] = (args...) ->
        args.unshift(tag)
        teacup[refer] args...
      bound[tag] = (args...) ->
        teacup[tag] args...
  bound
bound.bind = bind
for key of teacup
  do (key) ->
    if key.indexOf('_') != 0
      bound[key] = (args...) ->
        teacup[key] args...
elems =
  tag: mergeElements 'regular', 'obsolete'
  rawTag: mergeElements 'raw'
  selfClosingTag: mergeElements 'void', 'obsoleteVoid'
for refer of elems
  bind(elems[refer], refer)

# Exports

if module?.exports
  module.exports = bound
  module.exports.Teacup = Teacup
else if typeof define is 'function' and define.amd
  define('teacup', [], bound)
else
  window.teacup = bound
  window.teacup.Teacup = Teacup
