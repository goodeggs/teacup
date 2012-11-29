![teacup](https://raw.github.com/goodeggs/teacup/master/docs/teacup.jpg)

## Getting Started
Install

    $ npm install teacup

and render

    {render, div, h1} = require 'teacup/tags'
    
    render ->
      div '#sample', ->
        h1 -> 'Hello, world'

## Legacy
  [Markaby](/markaby/markaby) begat [CoffeeKup](/mauricemach/coffeekup) begat [CoffeeCup](/gradus/coffeecup) and [DryKup](/mark-hahn/drykup) which begat **Teacup**.

## Running Tests

    $ npm install
    $ npm test
