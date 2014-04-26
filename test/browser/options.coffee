assert = require('chai').assert

u = require '../../src/utils'

chrome = {
  runtime: {
    sendMessage: ->
  }
}

load_default_options = ->
  raw = u.readFile '../db.localstorage'
  for key,val of JSON.parse(raw)
      localStorage.setItem key, val

suite 'Options', ->

  setup ->
    load_default_options()

  teardown ->
   localStorage.clear()

  test 'load', ->
    assert.ok true
