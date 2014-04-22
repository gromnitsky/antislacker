u = require './utils'
DB = require './db'

class Counter

  # seconds
  @STEP = 5

  @TIMEOUT: ->
    Counter.STEP*1000

  constructor: (@domain) ->
    @id = u.randstr()
    @db = new DB @domain
    @timer = null
    @_lastIterCache = {}         # for unit tests

  log: (level, msg) ->
    u.puts level, "#{@constructor.name} #{@id}: #{@domain}", msg

  start: (func) ->
    @nextStep this, func

  finished: (val) ->
    val.elapsed >= val.limit

  tmpError: (val) ->
    if val.mutex && val.mutex != @id
      @log 1, "locked by #{val.mutex}"
      return true
    false

  nextStep: (ref, func) ->
    ref.db.get (val) ->
      ref._lastIterCache = val

      if ref.finished val
        val.mutex = null        # unlock
        ref.db.save val         # async, but we just hope for the best

        ref.log 1, 'DONE'
        func? 'DONE', ref
        return null

      if ref.tmpError val
        # restart again
        ref.timer = setTimeout ref.nextStep, Counter.TIMEOUT(), ref, func
        func? 'TMPERROR', ref
      else
        val.elapsed += Counter.STEP
        val.mutex = ref.id      # lock by current instance
        ref.db.save val, (ok) ->
          ref.log 1, "elapsed=#{val.elapsed}, limit=#{val.limit}"
          # restart again
          ref.timer = setTimeout ref.nextStep, Counter.TIMEOUT(), ref, func
        func? 'NEXT', ref

    null

  abort: ->
    clearTimeout @timer
    @db.get (val) =>
      if val
        val.mutex = null
        @db.save val
    @log 1, "aborted"

module.exports = Counter
