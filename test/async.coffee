expect = require 'expect.js'
{render, renderable, a, b, div, p, span, text} = require '..'

describe 'Async', ->

  it 'works synchronously', ->
    html = render ( ->
      div ->
        'hello world'
    )
    expect(html).to.equal '<div>hello world</div>'

  it 'works using render callback', (done) ->
    render ( ->
      div ->
        'hello world'
    ), (html) ->
      expect(html).to.equal '<div>hello world</div>'
      done()

  it 'works with a tag callback that is synchronous', (done) ->
    render ( ->
      div (done) ->
        text 'hello world'
        done()
    ), (html) ->
      expect(html).to.equal '<div>hello world</div>'
      done()

  it 'works with a tag callback that is asynchronous', (done) ->
    render ( ->
      div (done) ->
        setTimeout ( ->
          text 'hello world'
          done()
        ), 1
    ), (html) ->
      expect(html).to.equal '<div>hello world</div>'
      done()

  it 'works with 3 synchronous tag callbacks', (done) ->
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
  
  it 'works with 3 asynchronous tag callbacks', (done) ->
    render ( ->
      div (done) ->
        setTimeout ( ->
          text '1'
          div (done2) ->
            setTimeout ( ->
              text '2'
              div (done3) ->
                setTimeout ( ->
                  text '3'
                  done3()
                ), 1
              done2()
            ), 1
          done()
        ), 1
    ), (html) ->
      expect(html).to.equal '<div>1<div>2<div>3</div></div></div>'
      done()

  it 'works with tag callback and div content', (done) ->
    render ( ->
      div (done) ->
        setTimeout ( ->
          span ->
            'hello world'
          done()
        ), 10
    ), (html) ->
      expect(html).to.equal '<div><span>hello world</span></div>'
      done()
  
  it 'works with tag/text next to each others', (done) ->
    render ( ->
      span -> 'do'
      text 're'
      span -> 'me'
    ), (html) ->
      expect(html).to.equal '<span>do</span>re<span>me</span>'
      done()

  it 'works with multiple async calls in a tag callback', (done) ->
    render ( ->
      a ->
        '1'
      a (done) ->
        setTimeout ( ->
          text '2'
          setTimeout ( ->
            text '3'
            done()
          ), 1
        ), 1
      a ->
        '4'
    ), (html) ->
      expect(html).to.equal '<a>1</a><a>23</a><a>4</a>'
      done()

  it 'complex test 1', (done) ->
    render ( ->
      a ->
        '1'
      a (done) ->
        setTimeout ( ->
          text 'w'
          b -> '2'
          text 'x'
          setTimeout ( ->
            text 'y'
            b -> '3'
            text 'z'
            done()
          ), 10
        ), 10
      a ->
        '4'
    ), (html) ->
      expect(html).to.equal '<a>1</a><a>w<b>2</b>xy<b>3</b>z</a><a>4</a>'
      done()

  it 'async: async tag inside async tag needs to render in correct order', (done) ->
    render ( ->
      div ->
        a -> '1'
        span (done2) ->
          setTimeout ( ->
            b -> '2'
            done2()
          ), 10
        a -> '3'
    ), (html) ->
      expect(html).to.equal '<div><a>1</a><span><b>2</b></span><a>3</a></div>'
      done()

  it 'works with helpers', ->
    helper = ->
      p 'world'

    template = ->
      div ->
        helper()
        
    html = render template
    expect(html).to.equal '<div><p>world</p></div>'

  it 'allows template arguments', ->
    template = (user) ->
      div ->
        user.name
        
    html = render template, {name: 'bryant'}
    expect(html).to.equal '<div>bryant</div>'

  it 'renderable works', (done) ->
    template = renderable ( ->
      div ->
        'hello world'
    )
    template (html) ->
      expect(html).to.contain 'hello world'
      done()
