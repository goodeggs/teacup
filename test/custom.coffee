expect = require 'expect.js'
{render, tag, input, normalizeArgs} = require '..'

describe 'custom tag', ->
  it 'should render', ->
    template = -> tag 'custom'
    expect(render template).to.equal '<custom></custom>'
  it 'should render empty given null content', ->
    template = -> tag 'custom', null
    expect(render template).to.equal '<custom></custom>'
  it 'should render with attributes', ->
    template = -> tag 'custom', foo: 'bar', ping: 'pong'
    expect(render template).to.equal '<custom foo="bar" ping="pong"></custom>'
  it 'should render with attributes and content', ->
    template = -> tag 'custom', foo: 'bar', ping: 'pong', 'zag'
    expect(render template).to.equal '<custom foo="bar" ping="pong">zag</custom>'

describe 'custom tag-like', ->
  textInput = ->
    {attrs, contents} = normalizeArgs arguments
    attrs.type = 'text'
    input attrs, contents

  it 'should render', ->
    template = -> textInput()
    expect(render template).to.equal '<input type="text" />'

  it 'should accept a selector and attributes', ->
    template = -> textInput '.form-control', placeholder: 'Beep'
    expect(render template).to.equal '<input class="form-control" placeholder="Beep" type="text" />'
