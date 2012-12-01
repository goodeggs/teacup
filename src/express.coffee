CoffeeScript = require 'coffee-script' # We need require support for .coffee files

module.exports =
  renderFile: (path, options, callback) ->
    try
      callback null, require(path)(options)
    catch err
      callback err