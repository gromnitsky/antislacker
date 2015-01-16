# Example: http://dilbert.com/strip/2014-04-27

$ = require 'jquery'

randi = (min, max) ->
  Math.floor(Math.random() * (max - min + 1)) + min

# from 1989-04-16 up to yesterday
random_date = ->
  start = 577200000000
  day = 60*60*24*1000
  date = new Date(randi start, Date.now()-day)

  d = date.getDate()
  m = date.getMonth() + 1
  y = date.getFullYear()

  d = "0#{d}" if d < 10
  m = "0#{m}" if m < 10

  "#{y}-#{m}-#{d}"

class Comic

  @validate_date: (date) ->
    throw new Error "invalid date" unless date.match /^\d{4}-\d{2}-\d{2}$/

  @url: (date) ->
    Comic.validate_date date
    "http://dilbert.com/strip/#{date}"

  constructor: (selector, @date, @raw_html) ->
    Comic.validate_date @date
    throw new Error "invalid html" unless @raw_html

    @node = $(selector)
    throw new Error "cannot select #{selector}" unless @node

    @src = null
    @title = null

  _getImage: ->
    $(@raw_html)?.find "div.img-comic-container img"

  _getAttrs: ->
    @src = @_getImage()?.attr 'src'
    @title = @date

  draw: ->
    @_getAttrs()
    unless @src
      console.error "bad luck or redesign of Dilbert's site happened"
      return false

    @node.html "<a href='#{Comic.url @date}'><img src='#{@src}' title='#{@title}'></a>"
    true


# Main

dilbert_date = random_date()
dilbert = Comic.url dilbert_date
$.get dilbert, (data) ->
  comic = new Comic '#dilbert', dilbert_date, data
  console.error 'invalid img node' unless comic.draw()
.fail ->
  console.error "cannot fetch #{dilbert}"
