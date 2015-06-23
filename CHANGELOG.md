**v2.0.0** (2015-06-23)
- [HTML escape script tag content](https://github.com/goodeggs/teacup/pull/54). If you escape the content in your app, you can still nest @raw inside the script tag.

**v1.2.0** (2015-03-16)
- [Prevent buffer corruption](https://github.com/goodeggs/teacup/pull/51) combing teacup with express and fibers.

**v1.0.0** (2014-10-26)

 - Not a particularly significant release.  Bumped to 1.0 at [isaacs recommendation](https://github.com/npm/init-package-json/commit/363a17bc31bf653bb9575105eea62fb4664ad04b)
 - Add CHANGELOG.md
 - Expose a [plugin interface](README.md#plugins)
 - Extract camelCase to kebab-case conversion to [a plugin](https://github.com/goodeggs/teacup-camel-to-kebab)

**v0.4.2** (2014-07-19)

 - Convert camelCase attributes to kebab-case

**v0.4.1** (2014-05-28)

 - Use charAt instead of str[i] for better browser support

**v0.4.0** (2014-05-28)

 - Allow string returns from elements (ex: h1 -> 'hello')

**v0.3.1** (2014-02-27)

 - Prepend selector classes to attribute class

**v0.3.0** (2014-02-23)

 - Bump coffee-script to 1.7
 - Export normalizeArgs to simplify tag-like helpers

**v0.2.10** (2013-08-15)

 - False attribute value renders empty string
 - Don't print null if no contents

**v0.2.9** (2013-08-14)

 - Remove busted stack cleaning
 - Lose the -l flag compiling with CoffeeScript 1.6

**v0.2.8** (2013-05-16)

 - Revert to previous renderFile API but retain behavior
 - Fix self closing tag content check typo

**v0.2.7** (2013-04-06)

 - Document the `text` helper

**v0.2.6** (2013-02-06)

 - Renders objects and undefined

**v0.2.5** (2013-02-06)

 - 0 renders as '0' not ''
 - Configure travis-ci
 - Reference npm-installed mocha and coffee to avoid version differences
 - Expose teacup as an amd module
 - Add Backbone example to README
 - Fix github links in README

**v0.2.4** (2012-12-26)

 - Implemented `coffeescript` tag
 - connect-assets integration
 - Add browser docs
 - Link to Teacup::Rails

**v0.2.3** (2012-12-14)

 - Stop escaping single quotes. We always quote attributes with double quotes.
 - teacup.js is main teacup index file

**v0.2.2** (2012-12-09)

 - Scrub Teacup internals from V8 stack traces
 - Null contents are safely ignored
 - Fix busted package.json formatting

**v0.2.1** (2012-12-05)

 - Include usage examples.
 - Add LICENSE
 - Remove extraneous logging
 - Expose tag names in V8 stack traces
 - Commit compiled js

**v0.2.0** (2012-12-03)

 - Autoescape by default. Use `raw` to avoid escaping.
 - Expand data attribute
 - Add express integration

**v0.1.0** (2012-11-28)

 - Initial release
