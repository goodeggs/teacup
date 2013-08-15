###*
* Piplay
* Copyright(c) 2012-2013 PI Entertainment Limited <license@piplay.com>
* All rights reserved
*
* file: angular.coffee
* created_on: Wed Aug 14 21:59:53 2013
* updated_on: Wed Aug 14 23:42:07 2013
* created_by: Payne Chu <payne@piplay.com>
###

expect = require 'expect.js'
{ renderable, div, script } = require '..'

describe 'angular', ->
  it 'should support angular directive', ->
    template = renderable ->
      div { 'ng-view': null }
    expect(template()).to.equal('<div ng-view></div>')

  it 'should not render null', ->
    template = renderable ->
      script src: 'js/app.js'
    expect(template()).to.equal('<script src="js/app.js"></script>')

  it 'should support multiple contents', ->
    template = renderable ->
      div 'foo', ->
        div 'bar'
      , 'boo'
    expect(template()).to.equal('<div>foo<div>bar</div>boo</div>')
