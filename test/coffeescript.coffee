expect = require 'expect.js'
{renderable, coffeescript} = require '..'

describe 'coffeescript', ->
  it 'renders script tag and javascript with coffee preamble scoped only to that javascript', ->
    template = renderable -> coffeescript -> alert 'hi'
    expected =  """<script type="text/javascript">(function() {
      var __slice = [].slice,
          __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; },
          __hasProp = {}.hasOwnProperty,
          __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };
          (function () {
            return alert(\'hi\');
          })();
    })();</script>"""
    # Equal ignoring whitespace
    expect(template().replace(/[\n ]/g, '')).to.equal expected.replace(/[\n ]/g, '')


  it 'escapes the function contents for script tag', ->
    template = renderable -> coffeescript ->
      user = name: '</script><script>alert("alert");</script>'
      alert "Hello #{user.name}!"

    expect(template()).to.contain "'&lt;/script&gt;&lt;script&gt;alert(&quot;alert&quot;);&lt;/script&gt;'"

  # it 'string should render', ->
  #   t = -> coffeescript "alert 'hi'"
  #   assert.equal cc.render(t), "<script type=\"text/coffeescript\">alert 'hi'</script>"
  # it 'object should render', ->
  #   t = -> coffeescript src: 'script.coffee'
  #   assert.equal cc.render(t), "<script src=\"script.coffee\" type=\"text/coffeescript\"></script>"
