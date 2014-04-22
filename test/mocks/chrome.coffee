Storage = require 'dom-storage'
Storage.prototype.___save___ = ->
  # do nothing

localStorage = new Storage "#{__dirname}/../db.localstorage", { strict: true }

chrome = {
  runtime: {
    lastError: 'something happend'
    sendMessage: (json, func) ->
      switch json.msg
        when 'data:get'
          func {val: localStorage.getItem(json.key)}
        when 'data:save'
          localStorage.setItem json.key, JSON.stringify(json.val)
          func {ok: true}

      null
  }
}

module.exports = chrome
