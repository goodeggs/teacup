{renderable, p} = require '..'
emoji = require './express_template_partial'

module.exports = renderable ({name}) ->
  p "Name is #{name}"
  emoji()
