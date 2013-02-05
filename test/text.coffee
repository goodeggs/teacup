expect = require 'expect.js'
{renderable, text} = require '..'

describe 'text', ->
  it 'renders text verbatim', ->
    expect(renderable(text) 'foobar').to.equal 'foobar'

  it 'renders numbers', ->
    expect(renderable(text) 1).to.equal '1'
    expect(renderable(text) 0).to.equal '0'
