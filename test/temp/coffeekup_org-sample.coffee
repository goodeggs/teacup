expect = require 'expect.js'
{renderable, doctype, html, head, meta, link, style, title, script, body,
coffeescript, header, section, nav, footer, h1, h2, ul, li, a, p} = require '..'

describe 'coffeekup.org example', ->

  it 'works', ->
    x = title: 'Foo'
    path = '/zig'
    user = {}
    max = 12
    shoutify = (s) -> s.toUpperCase() + '!'

    template = renderable ->
      doctype 5
      html ->
        head ->
          meta charset: 'utf-8'
          title "#{x.title or 'Untitled'} | My awesome website"
          meta(name: 'description', content: desc) if desc?
          link rel: 'stylesheet', href: '/stylesheets/app.css'
          style '''
            body {font-family: sans-serif}
            header, nav, section, footer {display: block}
          '''
          script src: '/javascripts/jquery.js'
          # coffeescript ->
          #   $ ->
          #     alert 'Alerts are so annoying...'
        body ->
          header ->
            h1 x.title or 'Untitled'
            nav ->
              ul ->
                (li -> a href: '/', 'Home') unless path is '/'
                li -> a href: '/chunky', 'Bacon!'
                switch user.role
                  when 'owner', 'admin'
                    li -> a href: '/admin', 'Secret Stuff'
                  when 'vip'
                    li -> a href: '/vip', 'Exclusive Stuff'
                  else
                    li -> a href: '/commoners', 'Just Stuff'
          section ->
            h2 "Let's count to #{max}:"
            p i for i in [1..max]
          footer ->
            p shoutify('bye')

    expect(template()).to.contain 'Just Stuff'
