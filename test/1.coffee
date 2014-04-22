DB = require '../src/db.coffee'
db = new DB 'blog.example.com'

global.chrome = require './mocks/chrome'
Counter = require '../src/counter'

Counter.STEP = 1

c = new Counter 'blog.example.com'
c.start (status, ref) ->
  console.log "#{ref.id}, status=#{status}"
