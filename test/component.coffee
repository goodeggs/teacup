expect = require 'expect.js'
{component, div, render} = require '..'

console.log {component, div, render}
describe 'Component', ->

  it 'takes arguments', ->
    caption = component ({text}) ->
      div '.caption', text

    template = -> caption text: "Hello"
    expect(render template).to.equal '<div class="caption">Hello</div>'
