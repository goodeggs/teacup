expect = require 'expect.js'
teacup = require '..'

describe 'plugins', ->
  it 'are applied via use', ->
    console.log teacup
    expect(teacup.use).to.be.a 'function'
