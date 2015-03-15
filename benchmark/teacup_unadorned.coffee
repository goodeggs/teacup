# Lifted from coffeecup:
# https://github.com/gradus/coffeecup/blob/81bda8d28e626cf5b1e5105ec9bf01eef7ed6f7e/optimized_bench.coffee

{renderable, doctype, html, head, meta, link, style, title, script, body,
header, section, nav, footer, h1, h2, ul, li, a, p} = require '..'

module.exports = renderable ({title: titleText, inspired, users}) ->
  doctype 5
  html lang: 'en', ->
    head ->
      meta charset: 'utf-8'
      title titleText
      style '''
        body {font-family: "sans-serif"}
        section, header {display: block}
      '''
    body ->
      section ->
        header ->
          h1 titleText
        if inspired
          p 'Create a witty example'
        else
          p 'Go meta'
        ul ->
          for user in users
            li user.name
            li -> a href: "mailto:#{user.email}", -> user.email
