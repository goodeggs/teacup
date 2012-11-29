expect = require 'expect.js'
{render, escape, h1} = require '../tags'

describe 'Escaping', ->
  describe 'a script tag', ->
    it "adds HTML entities for sensitive characters", ->
      template = -> h1 escape "<script>alert('\"owned\" by c&a &copy;')</script>"
      expect(render template).to.equal "<h1>&lt;script&gt;alert(&#39;&quot;owned&quot; by c&amp;a &amp;copy;&#39;)&lt;/script&gt;</h1>"
