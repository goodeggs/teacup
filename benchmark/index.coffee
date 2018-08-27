fs = require 'fs'
Benchmark = require 'benchmark'

global.data = require './data'
loadTemplate = (filename) ->
  fs.readFileSync "#{__dirname}/#{filename}", encoding: 'utf8'

suite = new Benchmark.Suite()
.on 'cycle', (event) ->
  console.log event.target.toString()
.on 'error', (event) ->
  error = event.target.error
  console.error error.stack


# Teacup
unadorned = require './teacup_unadorned'
suite.add 'unadorned', ->
  unadorned data

# Jade
jade = require 'jade'
jadeUnadorned = jade.compile loadTemplate 'template.jade'
suite.add 'jade', -> jadeUnadorned data

# Underscore
_ = require 'underscore'
underscored = _.template loadTemplate 'underscore.html'
suite.add 'underscore', ->
  underscored data

underscoreNoWith = _.template loadTemplate('underscore_no_with.html'), variable: 'data' # noqa
suite.add 'underscore (no with)', ->
  underscoreNoWith data

# Dot
dots = require('dot').process path: "#{__dirname}/dot"
suite.add 'dot', ->
  dots.dot_template data

suite.run(async: true)

