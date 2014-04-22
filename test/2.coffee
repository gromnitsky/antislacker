DB = require '../src/db.coffee'
db = new DB 'blog.example.com'

global.chrome = require './mocks/chrome'
Counter = require '../src/counter'

Counter.TIMEOUT = 1000
c1 = new Counter 'blog.example.com'
c2 = new Counter 'blog.example.com'
c3 = new Counter 'blog.example.com'

c1.start().then (val) ->
  console.log val
.fail (err) ->
  console.log "c1 err=#{err}"
.done()

c2.start().then (val) ->
  console.log val

setTimeout ->
  c3.start().then (val) ->
    console.log val
  .fail (err) ->
    console.log "c3 err=#{err}"
  .done()
, 2000
