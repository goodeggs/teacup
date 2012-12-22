expect = require 'expect.js'
teacup = require '..'
connectAssets = require '../lib/connect-assets'

describe 'connect-assets middleware', ->

  it "registers js and css helpers with teacup", ->
    expect(teacup.js).to.be undefined
    expect(teacup.css).to.be undefined
    connectAssets()
    expect(teacup.js).to.be.a 'function'
    expect(teacup.css).to.be.a 'function'
