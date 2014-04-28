assert = require 'assert'

sinon = require 'sinon'

global.chrome = require './mocks/chrome'
Counter = require '../src/counter'
u = require '../src/utils'

u.VERBOSE = 0

suite 'Utils', ->
  test 'was_yesterday', ->
    assert.equal true, u.was_yesterday null

    assert.equal true, u.was_yesterday 1388500565233 # Tue Dec 31 2013
    assert.equal true, u.was_yesterday 1398607823004 # Apr 27 2014 2014
    assert.equal false, u.was_yesterday 12998500565233 # Fri Nov 27 2381
    assert.equal false, u.was_yesterday Date.now()

suite 'Counter', ->
  setup ->
    chrome._reset_localStorage()
    @clock = sinon.useFakeTimers Date.now()

  teardown ->
    @clock.restore()

  test 'smoke', ->
    c = new Counter 'blog.example.com'
    c.start (status, ref) ->
      assert.equal 'NEXT', status if c._lastIterCache.elapsed < 15
      m = ref._lastIterCache.mutex.split '/'
      assert m[1].match /^\d{13}$/
      assert.equal ref.id, m[0]

    @clock.tick 1
    assert.equal 5, c._lastIterCache.elapsed
    @clock.tick 10*1000
    assert.equal 15, c._lastIterCache.elapsed
    @clock.tick 15*1000
    assert.equal 15, c._lastIterCache.elapsed
    assert.equal true, c.finished(c._lastIterCache)

    c.start (status, ref) ->
      assert.equal 'DONE', status

  test 'race condition', ->
    c1 = new Counter 'blog.example.com'
    c2 = new Counter 'blog.example.com'

    c1.start()
    c2.start()

    assert.equal true, c2.tmpError(c2._lastIterCache)

    @clock.tick 10*1000
    assert.equal true, c2.tmpError(c2._lastIterCache)

    @clock.tick 15*1000
    assert.equal true, c1.finished(c1._lastIterCache)
    c2.start (status, ref) ->
      assert.equal 'DONE', status

  test 'disabled domain', ->
    c = new Counter 'facebook.com'
    times = 0
    c.start (status, ref) ->
      times += 1
      assert.equal 'TMPERROR', status if times <= 3

    @clock.tick 10*1000
    c.db.get (val) =>
      val.enabled = 1
      c.db.save val

    @clock.tick 15*1000
    c.start (status, ref) ->
      assert.equal 'DONE', status
