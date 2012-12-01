expect = require 'expect.js'
{render, div, img} = require '..'

describe 'CSS Selectors', ->
  describe 'id selector', ->
    it 'sets the id attribute', ->
      template = -> div '#myid', 'foo'
      expect(render template).to.equal '<div id="myid">foo</div>'

  describe 'one class selector', ->
    it 'adds an html class', ->
      template = -> div '.myclass', 'foo'
      expect(render template).to.equal '<div class="myclass">foo</div>'

  describe 'multi-class selector', ->
    it 'adds all the classes', ->
      template = -> div '.myclass.myclass2.myclass3', 'foo'
      expect(render template).to.equal '<div class="myclass myclass2 myclass3">foo</div>'

  describe 'wihout contents', ->
    it 'still adds attributes', ->
      template = -> img '#myid.myclass', src: '/pic.png'
      expect(render template).to.equal '<img id="myid" class="myclass" src="/pic.png" />'
