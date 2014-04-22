Q = require 'q'

u = require './utils'
DB = require './db'

class Counter

  @STEP = 5
  @TIMEOUT = Counter.STEP*1000

  constructor: (@domain) ->
    @id = u.randstr()
    @db = new DB @domain
    @timer = null

  log: (level, msg) ->
    u.puts level, "#{@constructor.name} #{@id}: #{@domain}", msg

  start: ->
    @nextStep this

  finished: (val) ->
    val.elapsed >= val.limit

  tmpError: (val) ->
    if val.mutex && val.mutex != @id
      @log 1, "locked by #{val.mutex}"
      return true
    false

  nextStep: (ref) ->
    deferred = Q.defer()

    ref.db.get()
    .then (val) ->
      if ref.finished val
        val.mutex = null        # unlock
        ref.db.save val

        ref.log 1, "DONE"
        deferred.resolve "DONE"
        return deferred.promise

      if ref.tmpError val
        # restart again
        ref.timer = setTimeout ref.nextStep, Counter.TIMEOUT, ref
        deferred.resolve 'TMPERROR'
      else
        val.elapsed += 1
        val.mutex = ref.id      # lock by current instance
        ref.db.save(val)
        .then ->
          ref.log 1, "elapsed=#{val.elapsed}, limit=#{val.limit}"
          # restart again
          ref.timer = setTimeout ref.nextStep, Counter.TIMEOUT, ref
          deferred.resolve "NEXT"
    .fail (err) ->
      console.error err
      deferred.reject new Error(err)
    .done()

    deferred.promise

  abort: ->
    clearTimeout @timer
    @db.get().then (val) ->
      if val
        val.mutex = null
        @db.save val
    .done()
    @log 1, "aborted"

module.exports = Counter
