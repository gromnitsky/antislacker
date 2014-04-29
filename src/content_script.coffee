u = require './utils'
Counter = require '../src/counter'

is_active_tab = (val) ->
  # https://developer.mozilla.org/en-US/docs/Web/Guide/User_experience/Using_the_Page_Visibility_API
  document.hidden

counter = new Counter domain, [is_active_tab]
counter.start (status, ref) ->
  u.puts 1, ref.id, status
  if status == 'DONE'
    window.location.href = chrome.extension.getURL('lib/message.html')

u.puts 0, 'content script', 'injected'
