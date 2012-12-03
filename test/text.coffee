expect = require 'expect.js'
{renderable, text} = require '..'

describe 'text', ->
  it 'renders text verbatim', ->
    expect(renderable(text) 'foobar').to.equal 'foobar'
