CoffeeScript = require 'coffee-script/register' # We need require support for .coffee files

module.exports =
  renderFile: (path, options, callback) ->
    setImmediate ->
      try
        # If express app does not have view cache enabled, clear the require cache
        if options.app? and not options.app.enabled('view cache')
          delete require.cache[require.resolve path]
        callback null, require(path)(options)
      catch err
        callback err
