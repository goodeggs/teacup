expect = require 'expect.js'
{render, raw, cede, div, p, strong, a} = require '..'

describe 'render', ->
  describe 'nested in a template', ->
    it 'returns the nested template without clobbering the parent result', ->
      template = ->
        p ->
          raw "This text could use #{render -> strong -> a href: '/', 'a link'}."
      expect(render template).to.equal '<p>This text could use <strong><a href="/">a link</a></strong>.</p>'

    it 'is aliased as cede', ->
      template = ->
        p ->
          raw "This text could use #{cede -> strong -> a href: '/', 'a link'}."
      expect(render template).to.equal '<p>This text could use <strong><a href="/">a link</a></strong>.</p>'

  it 'doesn\'t modify the attributes object', ->
    d = { id: 'foobar', class: 'myclass', href: 'http://example.com', }
    template = ->
      p ->
        a d, "link 1"
        a d, "link 2"
    expect(render template).to.equal '<p><a id="foobar" class="myclass" href="http://example.com">link 1</a><a id="foobar" class="myclass" href="http://example.com">link 2</a></p>'
