expect = require 'expect.js'
{component, div, render} = require '..'

console.log {component, div, render}
describe 'Component', ->

  it 'takes arguments', ->
    caption = component (caption) ->
      div '.caption', caption

    template = -> caption "Hello"
    expect(render template).to.equal '<div class="caption">Hello</div>'