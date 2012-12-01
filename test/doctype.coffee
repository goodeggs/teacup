expect = require 'expect.js'
{render, doctype} = require '..'

describe 'doctype', ->
  it 'default should render html5 doctype', ->
    template = -> doctype()
    expect(render template).to.equal '<!DOCTYPE html>'
  it 'xml should render xml header', ->
    template = -> doctype 'xml'
    expect(render template).to.equal '<?xml version="1.0" encoding="utf-8" ?>'
  it '5 should render html 5 doctype', ->
    template = -> doctype 5
    expect(render template).to.equal '<!DOCTYPE html>'
  it 'transitional should render transitional doctype', ->
    template = -> doctype 'transitional'
    expect(render template).to.equal '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
