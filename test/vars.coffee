expect = require 'expect.js'
{render, h1} = require '..'

describe 'Context data', ->
  it 'is an argument to the template function', ->
    template = ({foo}) -> h1 foo
    expect(render template, foo: 'bar').to.equal '<h1>bar</h1>'

describe 'Local vars', ->
  it 'are in the template function closure', ->
    obj = {foo: 'bar'}
    template = -> h1 "dynamic: #{obj.foo}"
    expect(render template).to.equal '<h1>dynamic: bar</h1>'
    obj.foo = 'baz'
    expect(render template).to.equal '<h1>dynamic: baz</h1>'
