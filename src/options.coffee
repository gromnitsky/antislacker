# Requires angularjs 1.2.17

u = require './utils'

ls_get = ->
  r = []
  for key,val of localStorage
    obj = JSON.parse val
    obj.domain = key
    r.push obj
  r

ls_save = (arr) ->
  return if arr.length == 0

  prevname = {}
  valid = true
  for idx in arr
    if prevname[idx.domain]
      valid = false
      alert "2 or more domain names #{idx.domain}"
      break

    prevname[idx.domain] = true

  return unless valid

  localStorage.clear()
  for idx in arr
    obj = {}
    obj[key] = val for key,val of idx when key != 'domain'
    u.puts 1, 'ls_save', idx.domain
    localStorage.setItem idx.domain, JSON.stringify obj

optionsApp = angular.module 'optionsApp', []

optionsApp.controller 'DomainCtrl', ($scope) ->
  $scope.domains = ls_get()
#  console.log $scope.domains

  $scope.$watch 'domains', (new_val) ->
    unless $scope.myform.$valid
      u.puts 0, 'DomainCtrl', 'invalid form'
      return

    ls_save $scope.domains
  , true

  $scope.rm = (domain) ->
    return unless domain
    if $scope.domains.length == 1
      alert 'Nah.'
      return

    return if (s = $scope.domains.indexOf(domain)) == -1
    $scope.domains.splice s, 1

  $scope.add = ->
    return unless $scope.myform.$valid
    obj = {
      domain: 'example.com'
      elapsed: 0
      enabled: true
      lastupdated: 0
      limit: 120
      mutex: null
    }
    $scope.domains.push obj

  $scope.reset = ->
    idx.elapsed = 0 for idx in $scope.domains

  $scope.hard_reset = ->
    $scope.domains = ls_get() if u.load_default_options 'db.localstorage'
