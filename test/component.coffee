expect = require 'expect.js'
{component, div, render} = require '..'

console.log {component, div, render}
describe 'Component', ->

  it 'takes arguments', ->
    caption = component (selector, {text}) ->
      div '.caption', text

    template = -> caption text: "Hello"
    expect(render template).to.equal '<div class="caption">Hello</div>'

  it 'passes along the selector', ->
    spinner = component (selector) ->
      div "#{selector}.spinner"

    template = -> spinner '.full-screen'
    expect(render template).to.equal '<div class="full-screen spinner"></div>'
