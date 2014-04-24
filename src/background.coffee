u = require './utils'

dz = require './domainzone'

inject_script = (tabId, changeInfo, tab) ->
  return unless changeInfo.status == 'complete'

  print_info = (t) -> u.puts 0, 'bg', "changeInfo.status=#{changeInfo.status}: script injected #{t}"

  for domain of localStorage
    if dz.Match domain, tab.url
      chrome.tabs.executeScript tabId, {code: "domain = '#{domain}'"}
      chrome.tabs.executeScript tabId, {file: 'lib/content_script.js'},
        print_info('lib/content_script.js')
    else
      u.puts 1, 'bg', "#{domain} not matched #{tab.url}"

u.load_default_options 'lib/db.localstorage'

# listen for any changes to the url of any tab
chrome.tabs.onUpdated.addListener inject_script

chrome.extension.onMessage.addListener (req, sender, sendRes) ->
  return unless req.msg

  switch req.msg
    when 'data:get'
      sendRes {val: localStorage.getItem(req.key)}
    when 'data:save'
      localStorage.setItem req.key, JSON.stringify(req.val)
      sendRes {ok: true}
    else
      throw new Error("unknown message name: #{req.msg}")

u.puts 0, 'bg', 'loaded'
