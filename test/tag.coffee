expect = require 'expect.js'
{renderable, p, div, script, ngChange, ngForm, ngInclude, ngPluralize} = require '..'

describe 'tag', ->
  it 'renders text verbatim', ->
    expect(renderable(p) 'foobar').to.equal '<p>foobar</p>'

  it 'renders numbers', ->
    expect(renderable(p) 1).to.equal '<p>1</p>'
    expect(renderable(p) 0).to.equal '<p>0</p>'

  it 'renders Dates', ->
    date = new Date(2013,1,1)
    expect(renderable(p) date).to.equal "<p>#{date.toString()}</p>"

  it "renders undefined as ''", ->
    expect(renderable(p) undefined).to.equal "<p></p>"

  it 'renders empty tags', ->
    template = renderable ->
      script src: 'js/app.js'
    expect(template()).to.equal('<script src="js/app.js"></script>')

  it 'renders multiple contents', ->
    template = renderable ->
      div 'foo', ->
        div 'bar'
      , 'boo'
    expect(template()).to.equal('<div>foo<div>bar</div>boo</div>')

  it 'renders angular tags', ->
    template = renderable ->
      ngChange 'foo'
      ngForm 'bar'
      ngInclude 'kaa'
      ngPluralize 'taa'
    expect(template()).to.equal('<ng-change>foo</ng-change><ng-form>bar</ng-form><ng-include>kaa</ng-include><ng-pluralize>taa</ng-pluralize>')
