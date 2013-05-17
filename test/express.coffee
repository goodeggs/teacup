expect = require 'expect.js'
{renderFile} = require '../lib/express'

describe 'express', ->
  describe 'renderFile', ->
    {path, params} = {}

    beforeEach ->
      path = "#{__dirname}/express_template.coffee"
      params = { name: 'Foo' }

    it 'renders a template from file', (done) ->
      renderFile path, params, (err, rendered) ->
        return done(err) if err?
        expect(rendered).to.equal '<p>Name is Foo</p>'
        done()

    it "returns error if not found", (done) ->
      renderFile './not_found.coffee', params, (err, rendered) ->
        expect(err).not.to.be(undefined)
        done()

    describe 'with view cache enabled', ->
      beforeEach ->
        params.app = {enabled: -> true}

      it 'loads from the require cache', (done) ->
        renderFile path, params, (err, rendered) ->
          return done(err) if err?
          expect(rendered).to.equal '<p>Name is Foo</p>'
          require(path).isSameTemplate = true
          renderFile path, params, (err, rendered) ->
            expect(require(path).isSameTemplate).to.be.ok()
            done()

    describe 'with view cache disabled', ->
      beforeEach ->
        params.app = {enabled: -> false}

      it 'does not use cached template', (done) ->
        renderFile path, params, (err, rendered) ->
          return done(err) if err?
          expect(rendered).to.equal '<p>Name is Foo</p>'
          require(path).isSameTemplate = true
          renderFile path, params, (err, rendered) ->
            expect(require(path).isSameTemplate).to.not.be.ok()
            done()
