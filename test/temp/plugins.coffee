expect = require 'expect.js'
teacup = require '..'

describe 'plugins', ->
  it 'are applied via use', ->
    expect(teacup.use).to.be.a 'function'
