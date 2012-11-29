expect = require 'expect.js'
{render, cede, div, p, strong, a} = require '../tags'

describe 'render', ->
  describe 'nested in a template', ->
    it 'returns the nested template without clobbering the parent result', ->
      template = -> 
        p "This text could use #{render -> strong -> a href: '/', 'a link'}."
      expect(render template).to.equal '<p>This text could use <strong><a href="/">a link</a></strong>.</p>'

    it 'is aliased as cede', ->
      template = -> 
        p "This text could use #{cede -> strong -> a href: '/', 'a link'}."
      expect(render template).to.equal '<p>This text could use <strong><a href="/">a link</a></strong>.</p>'
