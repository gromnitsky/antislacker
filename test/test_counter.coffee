assert = require 'assert'

sinon = require 'sinon'

global.chrome = require './mocks/chrome'
Counter = require '../src/counter'

suite 'Counter', ->
  setup ->
    @clock = sinon.useFakeTimers()

  teardown ->
    @clock.restore()

  test 'smoke', ->
    c = new Counter 'blog.example.com'
    c.start()

    @clock.tick 15*1000
