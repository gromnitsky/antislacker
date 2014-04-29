u = require './utils'
DB = require './db'

class Counter

  # seconds
  @STEP = 5

  @TIMEOUT: ->
    Counter.STEP*1000

  # @domain - a string
  #
  # @extTmperror - an array of functions, where each of them takes 1
  # argument & returns a boolean value. See #tmpError().
  constructor: (@domain, @extTmperror = []) ->
    throw new Error 'domain is required' unless @domain

    @id = u.randstr()
    @db = new DB @domain
    @timer = null
    @_lastIterCache = {}         # for unit tests

  log: (level, msg) ->
    u.puts level, "#{@constructor.name} #{@id}: #{@domain}", msg

  start: (func) ->
    @nextStep this, func

  finished: (val) ->
    if u.was_yesterday val.lastupdated
      val.elapsed = 0
      @log 1, 'long time no see'
    val.elapsed >= val.limit

  tmpError: (val) ->
    return true unless val.enabled

    (return true if func val) for func in @extTmperror

    if val.mutex
      mutex = val.mutex.split '/'
      return false if mutex[0] == @id

      if (Date.now()-mutex[1]) < Counter.TIMEOUT()*2
        @log 1, "locked by #{val.mutex}"
        return true

    false

  nextStep: (ref, func) ->
    ref.db.get (val) ->
      throw new Error("#{ref.id} got null from db.get()") unless val

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
        val.lastupdated = Date.now()
        val.mutex = "#{ref.id}/#{Date.now()}" # lock by current instance

        ref._lastIterCache = val
        ref.db.save val, (ok) ->
          ref.log 1, "elapsed=#{val.elapsed}, limit=#{val.limit}"
          # restart again
          ref.timer = setTimeout ref.nextStep, Counter.TIMEOUT(), ref, func
        func? 'NEXT', ref

    null

  abort: ->
    clearTimeout @timer
    @log 1, "aborted"

module.exports = Counter
