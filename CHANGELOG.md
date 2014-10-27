**in progress**

 - add CHANGELOG.md

**v0.4.1** (2014-05-28)

 - use charAt instead of str[i] for better browser support

**v0.4.0** (2014-05-28)

 - allow string returns from elements (ex: h1 -> 'hello')

**v0.3.1** (2014-02-27)

 - Prepend selector classes to attribute class

**v0.3.0** (2014-02-23)

 - bump coffee-script to 1.7
 - export normalizeArgs to simplify tag-like helpers
 - Test more nested hyphenated attributes

**v0.2.10** (2013-08-15)

 - false attribute value should render empty string
 - should not print null if no contents
 - renders empty tags test

**v0.2.9** (2013-08-14)

 - Remove busted stack cleaning
 - Lose the -l flag to compile with CoffeeScript 1.6

**v0.2.8** (2013-05-16)

 - Revert to previous renderFile API but retain behavior
 - Abide by the Express view cache setting
 - Fix self closing tag content check typo

**v0.2.7** (2013-04-06)

 - Document the text helper
 - Rails and Express are like neighbors
 - Noodling on the README intro

**v0.2.6** (2013-02-06)

 - Renders objects and undefined

**v0.2.5** (2013-02-06)

 - 0 should render as '0' not ''
 - Add travis-ci configuration and status image
 - Reference npm-installed mocha and coffee to avoid version differences
 - Revert unintentional changes to compiled JS
 - Expose teacup as an amd module
 - Add Backbone example to README
 - Fix github links in README:

**v0.2.4** (2012-12-26)

 - 0.2.4 with coffeescript tag
 - Add browser docs
 - Link to Teacup::Rails
 - connect-assets docs
 - Merge branch 'connect-assets'
 - connect-assets middleware registers js and css helpers with teacup
 - Add __indexOf to coffeescript tag output
 - Implemented coffeescript tag

**v0.2.3** (2012-12-14)

 - Do not escape single quotes b/c we always quote attributes with doub;e quotes
 - teacup.js is main teacup index file

**v0.2.2** (2012-12-09)

 - Scrub Teacup internals from V8 stack traces
 - Null contents are safely ignored
 - fix busted package.json formatting

**v0.2.1** (2012-12-05)

 - Add homepage url
 - Include usage examples.
 - Add LICENSE
 - Name template file
 - Remove extraneous logging
 - Expose tag names in V8 stack traces
 - Commit compiled js

**v0.2.0** (2012-12-03)

 - Autoescape by default. Use raw to avoid escaping
 - Expand data attribute
 - Add express docs
 - Implement express.renderFile
 - index exports tags, Teacup and renderFile
 - Compile src coffee to lib

**v0.1.0** (2012-11-28)

 - ...eeeeeEEEEEEEEE!! Tea is ready

**v0.0.0** (2012-11-28)

 - initial commit
