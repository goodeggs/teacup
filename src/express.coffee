CoffeeScript = require 'coffee-script' # We need require support for .coffee files

module.exports = (expressApp) ->
  (path, options, callback) ->
    try
      unless expressApp.enabled('view cache')
        delete require.cache[require.resolve path]
      callback null, require(path)(options)
    catch err
      callback err
