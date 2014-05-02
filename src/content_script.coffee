u = require './utils'
Counter = require '../src/counter'

page_mark = ->
  body = document.querySelector 'body'
  body.setAttribute 'data-antislacker', chrome.runtime.id

page_is_already_loaded = ->
  body = document.querySelector 'body'
  body.getAttribute('data-antislacker') == chrome.runtime.id

is_active_tab = (val) ->
  # https://developer.mozilla.org/en-US/docs/Web/Guide/User_experience/Using_the_Page_Visibility_API
  document.hidden

# protect from double/triple/etc counter startups in case of xhr
if page_is_already_loaded()
  u.puts 0, 'content script', 'already loaded'
  return

page_mark()

counter = new Counter domain, [is_active_tab]
counter.start (status, ref) ->
  u.puts 1, ref.id, status
  if status == 'DONE'
    window.location.href = chrome.extension.getURL('lib/message.html')

u.puts 0, 'content script', 'injected'
