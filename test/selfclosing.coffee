expect = require 'expect.js'
{renderable, img, br, link} = require '../lib/tags'

describe 'Self Closing Tags', ->
  describe '<img />', ->
    it 'should render', ->
      expect(renderable(img)()).to.equal '<img />'
    it 'should render with attributes', ->
      expect(renderable(img) src: 'http://foo.jpg.to')
        .to.equal '<img src="http://foo.jpg.to" />'
  describe '<br />', ->
    it 'should render', ->
      expect(renderable(br)()).to.equal '<br />'
  describe '<link />', ->
    it 'should render with attributes', ->
      expect(renderable(link) href: '/foo.css', rel: 'stylesheet')
        .to.equal '<link href="/foo.css" rel="stylesheet" />'
