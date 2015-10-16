expect = require 'expect.js'
{render, div, text} = require '..'

describe 'Async', ->

  it 'test', ->
    html = render ( ->
      div ->
        'hello world'
    )
    expect(html).to.equal '<div>hello world</div>'
    throw new Error('stop')

  it 'sync renders successfully', ->
    html = render ( ->
      div (a, b, c) ->
        console.log 'a', a, 'b', b, 'c', c
        'hello world'
    )
    expect(html).to.equal '<div>hello world</div>'

  it 'sync renders successfully with callback', ->
    render ( ->
      div ->
        'hello world'
    ), (html) ->
      expect(html).to.equal '<div>hello world</div>'

  it 'async renders successfully with callback', ->
    render ( ->
      div (done) ->
        text 'hello world'
        console.log 'done', done
        done()
    ), (html) ->
      expect(html).to.equal '<div>hello world</div>'

  it 'async renders successfully with callback and async contents', ->
    render ( ->
      div (done) ->
        #setTimeout ( ->
        text 'hello world'
        done()
        #), 1000
    ), (html) ->
      expect(html).to.equal '<div>hello world</div>'
