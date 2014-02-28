expect = require 'expect.js'
{render, a, br, div} = require '..'

describe 'Attributes', ->

  describe 'with a hash', ->
    it 'renders the corresponding HTML attributes', ->
      template = -> a href: '/', title: 'Home'
      expect(render template).to.equal '<a href="/" title="Home"></a>'

  describe 'Boolean true value', ->
    it 'is replaced with the attribute name.  Useful for attributes like disabled', ->
      template = -> br foo: yes, bar: true
      expect(render template).to.equal '<br foo="foo" bar="bar" />'

  describe 'Boolean false value', ->
    it 'is omitted', ->
      template = -> br foo: no, bar: false
      expect(render template).to.equal '<br />'

  describe 'null and undefined value', ->
    it 'renders just the attribute name', ->
      template = -> br foo: null, bar: undefined
      expect(render template).to.equal '<br foo bar />'

  describe 'string value', ->
    it 'is used verbatim', ->
      template = -> br foo: 'true', bar: 'str'
      expect(render template).to.equal '<br foo="true" bar="str" />'

  describe 'number value', ->
    it 'is stringified', ->
      template = -> br foo: 2, bar: 15.55
      expect(render template).to.equal '<br foo="2" bar="15.55" />'

  describe 'array value', ->
    it 'is comma separated', ->
      template = -> br foo: [1, 2, 3]
      expect(render template).to.equal '<br foo="1,2,3" />'

  describe 'data attribute', ->
    it 'expands attributes', ->
      template = -> br data: { name: 'Name', value: 'Value' }
      expect(render template).to.equal '<br data-name="Name" data-value="Value" />'

  describe 'nested hyphenated attribute', ->
    it 'renders', ->
      template = ->
        div 'on-x': 'beep', ->
          div 'on-y': 'boop'
      expect(render template).to.equal '<div on-x="beep"><div on-y="boop"></div></div>'
