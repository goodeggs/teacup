expect = require 'expect.js'
{render, div, text} = require '..'

describe 'rendering flow', ->

  it 'sync render', ->
    html = render ( ->
      div ->
        'hello world'
    )
    expect(html).to.equal '<div>hello world</div>'

  it 'sync render with sync tag callback', ->
    html = render ( ->
      div (done) ->
        text 'hello world'
        done()
    )
    expect(html).to.equal '<div>hello world</div>'

  it 'async render', (done) ->
    render ( ->
      div ->
        'hello world'
    ), (html) ->
      expect(html).to.equal '<div>hello world</div>'
      done()

  it 'async render with sync tag callback', (done) ->
    render ( ->
      div (done) ->
        text 'hello world'
        done()
    ), (html) ->
      expect(html).to.equal '<div>hello world</div>'
      done()

  it 'async render with 3 sync tag callbacks', (done) ->
    render ( ->
      div (done) ->
        console.log 'in div 1'
        div (done2) ->
          console.log 'in div 2'
          div (done3) ->
            console.log 'in div 3'
            text 'hello world'
            done()
            done2()
            done3()
    ), (html) ->
      expect(html).to.equal '<div><div><div>hello world</div></div></div>'
      done()

  ###
  it 'async render with async tag callback and text content', (done) ->
    render ( ->
      div (done) ->
        console.log ' in div'
        setTimeout ( ->
          console.log 'in timeout'
          text 'hello world'
          console.log 'done'
          done()
        ), 100
    ), (html) ->
      expect(html).to.equal '<div>hello world</div>'
      done()

  it 'async render with async tag callback and div content', (done) ->
    render ( ->
      div (done) ->
        console.log 'in div'
        setTimeout ( ->
          console.log 'in timeout'
          div ->
            console.log 'in div 2'
            text 'hello world'
          done()
        ), 100
    ), (html) ->
      expect(html).to.equal '<div><div>hello world</div></div>'
      done()
  ###
