url = require 'url'

class DomainZone

  constructor: (@raw) ->
    throw new Error 'invalid input string' unless DomainZone.Validate(@raw)

  @Validate: (raw) ->
    return false unless raw?.match /^\S{3,}$/
    (return false if idx == '') for idx in raw.split('.')
    true

  match: (uri) ->
    host = url.parse(uri).host
    return false if host == ""

    rule = @raw.split '.'
    host = host.split '.'

    return false if rule.length > host.length

    start = host.length - rule.length
    ruleIdx = 0
    for val,idx in host when idx >= start
#      console.log "%s ? %s", val, rule[ruleIdx]
      return false if val != rule[ruleIdx++]

    true

  @Match: (rule, uri) ->
    try
      dz = new DomainZone(rule)
    catch e
      false

    dz.match uri

  toString: ->
    @raw.toString()

module.exports = DomainZone
