expect = require 'expect.js'
{renderFile} = require '../lib/express'

describe 'express', ->
  describe 'renderFile', ->
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

