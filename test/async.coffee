expect = require 'expect.js'
{render, a, div, span, text} = require '..'

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
        text '1'
        div (done2) ->
          text '2'
          div (done3) ->
            text '3'
            done3()
          done2()
        done()
    ), (html) ->
      expect(html).to.equal '<div>1<div>2<div>3</div></div></div>'
      done()

  it 'async render with async tag callback and text content', (done) ->
    render ( ->
      div (done) ->
        setTimeout ( ->
          text 'hello world'
          done()
        ), 10
    ), (html) ->
      expect(html).to.equal '<div>hello world</div>'
      done()

  it 'async render with async tag callback and div content', (done) ->
    render ( ->
      div (done) ->
        setTimeout ( ->
          div ->
            text 'hello world'
          done()
        ), 10
    ), (html) ->
      expect(html).to.equal '<div><div>hello world</div></div>'
      done()

  it 'async: async tag between two sync tags', (done) ->
    render ( ->
      div ->
        '1'
      div (done) ->
        setTimeout ( ->
          text '2'
          done()
        )
      div ->
        '3'
    ), (html) ->
      expect(html).to.equal '<div>1</div><div>2</div><div>3</div>'
      done()

  it 'async: multiple timeouts', (done) ->
    render ( ->
      div ->
        '1'
      div (done) ->
        setTimeout ( ->
          text '2'
          setTimeout ( ->
            text '3'
            done()
          ), 10
        ), 10
      div ->
        '4'
    ), (html) ->
      expect(html).to.equal '<div>1</div><div>23</div><div>4</div>'
      done()

  it 'async: complex 1', (done) ->
    render ( ->
      div ->
        '1'
      div (done) ->
        setTimeout ( ->
          span -> '2'
          setTimeout ( ->
            span -> '3'
            done()
          ), 10
        ), 10
      div ->
        '4'
    ), (html) ->
      expect(html).to.equal '<div>1</div><div><span>2</span><span>3</span></div><div>4</div>'
      done()

  it 'async: complex 2', (done) ->
    render ( ->
      div (done) ->
        text '2'
        setTimeout ( ->
          a -> '3'
          div (done2) ->
            setTimeout ( ->
              a -> '5'
              done2()
            ), 10
          done()
        ), 10
    ), (html) ->
      expect(html).to.equal '<div>1</div><div><span>2</span><span>3</span></div><div>4</div>'
      done()
