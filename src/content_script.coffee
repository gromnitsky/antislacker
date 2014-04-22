u = require './utils'
Counter = require '../src/counter'

counter = new Counter domain
counter.start (status, ref) ->
  u.puts 1, ref.id, status
  if status == 'DONE'
    window.location.href = chrome.extension.getURL('lib/message.html')

window.addEventListener "beforeunload", (event) ->
  u.puts 0, 'content script', 'beforeunload'
  counter.abort()
, false

u.puts 0, 'content script', 'injected'