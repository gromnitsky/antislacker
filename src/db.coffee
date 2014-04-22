class DB

  constructor: (@domain) ->

  # Get a whole block at once.
  get: (func) ->
    if !func?
      throw new Error('callback required')

    chrome.runtime.sendMessage {msg: "data:get", key: @domain}, (res) ->
      if !res
        func null
        return

      try
        r = JSON.parse res.val
      catch e
        r = null

      func r

    null

  # Save a whole block at once.
  save: (val, func) ->
    chrome.runtime.sendMessage {msg: "data:save", key: @domain, val: val}, (res) ->
      r = if !res?.ok then {ok:false} else res.ok
      func?(r)
    null


module.exports = DB
