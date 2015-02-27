expect = require 'expect.js'
{component, div, render, img} = require '..'

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

  it 'passes along child content', ->
    captioned = component (selector, {text}, renderContents) ->
      div '.captioned', ->
        renderContents()
        div '.caption', text

    template = ->
      captioned text: 'La Dura Dura', ->
        img src: '/catalonia/IMG_00182.JPG'

    expect(render template).to.equal '<div class="captioned"><img src="/catalonia/IMG_00182.JPG" /><div class="caption">La Dura Dura</div></div>'