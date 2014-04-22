DB = require '../src/db.coffee'
db = new DB 'blog.example.com'

global.chrome = require './mocks/chrome'
Counter = require '../src/counter'

c = new Counter 'blog.example.com'
c.start()
