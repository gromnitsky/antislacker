exports.VERBOSE = 1

exports.puts = (level, who) ->
  arguments[2] = "#{who}: #{arguments[2]}" if arguments?.length > 2 && who != ""
  msg = (val for val, idx in arguments when idx > 1)
  console.log.apply(console, msg) if level <= exports.VERBOSE

# From stackoverflow so it must be solid.
exports.uuid = ->
  buf = new Uint16Array(8)
  window.crypto.getRandomValues buf
  S4 = (num) ->
    ret = num.toString(16);
    ret = "0"+ret while (ret.length < 4)
    ret

  (S4(buf[0])+S4(buf[1])+"-"+S4(buf[2])+"-4"+S4(buf[3]).substring(1)+"-y"+S4(buf[4]).substring(1)+"-"+S4(buf[5])+S4(buf[6])+S4(buf[7]))

exports.randstr = ->
  Math.random().toString(36).substring(2)

# Return a string or null on error.
exports.readFile = (file) ->
  content = null
  fp = new XMLHttpRequest()
  try
    fp.open "GET", file, false
    fp.send null
    content = fp.responseText
  catch e
    exports.puts 0, 'readFile', 'cannot load %s: %s', file, e

  content

exports.load_default_options = (file, clear_old = false) ->
  raw = exports.readFile file
  return false unless raw

  localStorage.clear() if clear_old
  return true if localStorage.length != 0

  for key,val of JSON.parse(raw)
    if clear_old || !localStorage.getItem(key)
      localStorage.setItem key, val

  true

exports.was_yesterday = (num) ->
  date = new Date num
  year = date.getFullYear()
  month = date.getMonth()
  day = date.getDate()

  now = new Date()
  cur_year = now.getFullYear()
  cur_month = now.getMonth()
  cur_day = now.getDay()

#  console.log "#{year} #{month} #{day} vs. #{cur_year} #{cur_month} #{cur_day}"
  return true if (year < cur_year) || (month < cur_month)
  day < cur_day
