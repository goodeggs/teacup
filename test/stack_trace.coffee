expect = require 'expect.js'
{renderable, div, p} = require '..'

describe 'stack trace', ->
  it 'should contain tag names', ->
    template = renderable ->
      div ->
        p ->
          throw new Error()
    try
      template()
    catch error
      expect(error.stack).to.contain 'div'
      expect(error.stack).to.contain 'p'
