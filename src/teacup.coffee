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
    string.length > 1 and string[0] in ['#', '.']  

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
    for arg, index in args
      switch typeof arg
        when 'string'
          if index is 0 and @isSelector(arg)
            selector = @parseSelector(arg)
          else
            contents = arg
        when 'function', 'number', 'boolean'
          contents = arg
        when 'object'
          attrs = arg
        else  
          console.log "Teacup: invalid argument: #{arg.toString()}"

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
      throw new Error "Teacup: <#{tag}/> must not have content.  Attempted to nest #{content}"
    @raw "<#{tag}#{@renderAttrs attrs} />"

  coffeescript: ->
    throw new Error 'Teacup: coffeescript tag not implemented'

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
    @htmlOut += s and @escape(s.toString()) or ''

  raw: (s) ->
    @htmlOut += s

  #
  # Filters
  # return strings instead of appending to buffer
  #
  escape: (text) ->
    text.toString().replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;')

  quote: (value) ->
    q = (if '"' in value then "'" else '"')
    return q + value + q

  #
  # Binding
  #
  tags: ->
    bound = {}
    for method in 'cede coffeescript comment doctype escape ie raw render renderable script tag text'.split(' ') 
      do (method) =>
        bound[method] = (args...) => @[method].apply @, args

    for tagName in merge_elements 'regular', 'obsolete'
      do (tagName) =>
        bound[tagName] = (args...) => @tag tagName, args...

    for tagName in merge_elements 'raw'
      do (tagName) =>
        bound[tagName] = (args...) => @rawTag tagName, args...
        
    for tagName in merge_elements 'void', 'obsolete_void'
      do (tagName) =>
        bound[tagName] = (args...) => @selfClosingTag tagName, args...

    return bound

if module?.exports
  module.exports = Teacup
else 
  window.teacup = Teacup
  
