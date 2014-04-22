u = require './utils'

init_options = ->
  raw = u.readFile 'lib/db.localstorage'
  localStorage.setItem key, val for key,val of JSON.parse raw

init_options()
console.log "bg: loaded"
