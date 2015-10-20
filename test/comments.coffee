expect = require 'expect.js'
{render, comment} = require '..'

describe 'Comments', ->
  it 'renders HTML <!--comments-->', ->
    template = -> comment "Comment"
    expect(render template).to.equal '<!--Comment-->'
