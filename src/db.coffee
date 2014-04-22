Q = require 'q'

class DB

  constructor: (@domain) ->

  # Get a whole block at once. Return a promise.
  get: ->
    deferred = Q.defer()
    chrome.runtime.sendMessage {msg: "data:get", key: @domain}, (res) ->
      r = {}
      try
        throw new Error(chrome.runtime.lastError) unless res
        r = JSON.parse res.val
      catch e
        deferred.reject e
      deferred.resolve r

    deferred.promise

  # Save a whole block at once. Return a promise.
  save: (val) ->
    deferred = Q.defer()
    chrome.runtime.sendMessage {msg: "data:save", key: @domain, val: val}, (res) ->
      if !res?.ok
        deferred.reject new Error(chrome.runtime.lastError)
      else
        deferred.resolve res.ok

    deferred.promise


module.exports = DB
