DB = require '../src/db.coffee'
db = new DB 'blog.example.com'

global.chrome = require './mocks/chrome'
Counter = require '../src/counter'

Counter.STEP = 1

c1 = new Counter 'blog.example.com'
c2 = new Counter 'facebook.com'

c1.start (status, ref) ->
  console.log "c1 #{ref.id}, status=#{status}"

c2.start (status, ref) ->
  console.log "c2 #{ref.id}, status=#{status}"

setTimeout ->
  c2.db.get (val) ->
    val.enabled = 1
    c2.db.save val, (ok) ->
      c2.log 1, "enabled"
, 3000
