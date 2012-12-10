expect = require 'expect.js'
{render, tag} = require '..'

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
