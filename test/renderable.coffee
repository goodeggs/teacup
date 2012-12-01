expect = require 'expect.js'
{renderable, div, span} = require '..'

describe 'renderable decorator', ->
  it 'makes a template directly callable', ->
    template = renderable (letters) ->
      for letter in letters
        div letter

    expect(template ['a', 'b', 'c'])
      .to.equal '<div>a</div><div>b</div><div>c</div>'

  it 'supports composition with renderable and non-renderable helpers', ->
    
    renderableHelper = renderable (user) ->
      span user.first

    vanillaHelper = (user) ->
      span user.last

    template = renderable (user) ->
      div ->
        renderableHelper(user)
        vanillaHelper(user)

    expect(template first:'Huevo', last:'Bueno')
      .to.equal '<div><span>Huevo</span><span>Bueno</span></div>'
