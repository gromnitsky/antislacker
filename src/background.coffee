u = require './utils'

dz = require './domainzone'

show_icon = (domain, tabId) ->
  chrome.pageAction.show tabId
  chrome.pageAction.setTitle {tabId: tabId, title: "Domain matched: #{domain}"}

inject_script_and_icon = (tabId, changeInfo, tab) ->
  return unless changeInfo.status == 'complete'

  print_info = (t) -> u.puts 2, 'bg', "changeInfo.status=#{changeInfo.status}: script injected #{t}"

  for domain of localStorage
    if dz.Match domain, tab.url
      chrome.tabs.executeScript tabId, {code: "domain = '#{domain}'"}
      chrome.tabs.executeScript tabId, {file: 'lib/content_script.js'},
        print_info('lib/content_script.js')
      show_icon domain, tabId
    else
      u.puts 2, 'bg', "#{domain} not matched #{tab.url}"

matching_tabs_count = (func) ->
  chrome.tabs.query {}, (arr) ->
    r = 0
    for idx in arr
      for domain of localStorage
        r++ if dz.Match(domain, idx.url)

    func?(r)

matching_tabs_close = ->
  chrome.tabs.query {}, (arr) ->
    for idx in arr
      for domain of localStorage
        if dz.Match domain, idx.url
          u.puts 1, 'bg', "closing #{idx.url}"
          chrome.tabs.remove idx.id

u.load_default_options 'lib/db.localstorage'

# listen for any changes to the url of any tab
chrome.tabs.onUpdated.addListener inject_script_and_icon

chrome.extension.onMessage.addListener (req, sender, sendRes) ->
  return unless req.msg

  switch req.msg
    when 'data:get'
      sendRes {val: localStorage.getItem(req.key)}
    when 'data:save'
      localStorage.setItem req.key, JSON.stringify(req.val)
      sendRes {ok: true}
    when 'tabs:count'
      matching_tabs_count (n) ->
        sendRes {count: n}
    when 'tabs:close'
      matching_tabs_close()
    else
      throw new Error("unknown message name: #{req.msg}")

  true                          # keep this

u.puts 0, 'bg', 'loaded'
