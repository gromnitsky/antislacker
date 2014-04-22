DB = require '../src/db.coffee'
db = new DB 'blog.example.com'

global.chrome = require './mocks/chrome'
Counter = require '../src/counter'

Counter.STEP = 1

c1 = new Counter 'blog.example.com'
c2 = new Counter 'blog.example.com'
c3 = new Counter 'blog.example.com'

c1.start (status, ref) ->
  console.log "c1 #{ref.id}, status=#{status}"

c2.start (status, ref) ->
  console.log "c2 #{ref.id}, status=#{status}"

setTimeout ->
  c3.start (status, ref) ->
    console.log "c3 #{ref.id}, status=#{status}"
, 2000

setTimeout ->
  c1.abort()
, 3000
