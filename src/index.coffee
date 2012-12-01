Teacup = require './teacup'
CoffeeScript = require 'coffee-script' # We need require support for .coffee files

module.exports = new Teacup().tags()

module.exports.Teacup = Teacup

module.exports.renderFile = (path, options, callback) ->
  console.log "Render", path, options
  try
    callback null, require(path)(options)
  catch err
    callback err