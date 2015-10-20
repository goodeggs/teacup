expect = require 'expect.js'
{render, div, p} = require '..'

describe 'nesting templates', ->
  it 'renders nested template in the same output', ->
    user = 
      first: 'Huevo'
      last: 'Bueno'

    nameHelper = (user) ->
      p "#{user.first} #{user.last}"

    template = (user) ->
      div ->
        nameHelper user

    expect(render template, user).to.equal '<div><p>Huevo Bueno</p></div>'
