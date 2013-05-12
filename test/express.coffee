expect = require 'expect.js'

describe 'express', ->
  describe 'renderFile', ->
    path = "#{__dirname}/express_template.coffee"
    params = { name: 'Foo' }
    fakeExpress = {enabled: -> true}
    renderFile = require('../lib/express') fakeExpress
    
    it 'renders a template from file', (done) ->
      renderFile path, params, (err, rendered) ->
        return done(err) if err?
        expect(rendered).to.equal '<p>Name is Foo</p>'
        done()

    it 'can fetch from the require cache', (done) ->
      renderFile path, params, (err, rendered) ->
        return done(err) if err?
        expect(rendered).to.equal '<p>Name is Foo</p>'
        require(path).isSameTemplate = true
        renderFile path, params, (err, rendered) ->
          expect(require(path).isSameTemplate).to.be.ok()
          done()

    it 'can ignore the require cache', (done) ->
      renderFile path, params, (err, rendered) ->
        return done(err) if err?
        expect(rendered).to.equal '<p>Name is Foo</p>'
        require(path).isSameTemplate = true
        fakeExpress.enabled = -> false
        renderFile path, params, (err, rendered) ->
          expect(require(path).isSameTemplate).to.not.be.ok()
          done()

    it 'renders a template from file', (done) ->
      path = "#{__dirname}/express_template.coffee"
      params = { name: 'Foo' }

      renderFile path, params, (err, rendered) ->
        return done(err) if err?
        expect(rendered).to.equal '<p>Name is Foo</p>'
        done()

    it "returns error if not found", (done) ->
      path = './not_found.coffee'

      renderFile path, {}, (err, rendered) ->
        expect(err).not.to.be(undefined)
        done()

