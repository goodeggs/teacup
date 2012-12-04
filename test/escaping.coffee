expect = require 'expect.js'
{render, raw, escape, h1, input} = require '..'

describe 'Auto escaping', ->
  describe 'a script tag', ->
    it "adds HTML entities for sensitive characters", ->
      template = -> h1 "<script>alert('\"owned\" by c&a &copy;')</script>"
      expect(render template).to.equal "<h1>&lt;script&gt;alert(&#39;&quot;owned&quot; by c&amp;a &amp;copy;&#39;)&lt;/script&gt;</h1>"

  it 'escapes tag attributes', ->
    template = -> input name: '"pwned'
    expect(render template).to.equal '<input name="&quot;pwned" />'

describe 'raw filter', ->
  it 'prints sensitive characters verbatim', ->
    template = -> raw "<script>alert('on purpose')</script>"
    expect(render template).to.equal "<script>alert('on purpose')</script>"

  describe 'combined with the escape filter', ->
    it 'gives the author granular control of escaping', ->
      template = ->
        raw "<script>alert('#{escape 'perfect <3'}')</script>"
      expect(render template).to.equal "<script>alert('perfect &lt;3')</script>"

