# Requires angularjs 1.2.17

ls_get = ->
  r = []
  for key,val of localStorage
    obj = JSON.parse val
    obj.domain = key
    r.push obj
  r

ls_save = ->
  # todo

optionsApp = angular.module 'optionsApp', []

optionsApp.controller 'DomainCtrl', ($scope) ->
  $scope.domains = ls_get()
#  console.log $scope.domains

  $scope.$watch 'domains', (new_val) ->
    console.log new_val
    console.log 'invalid form' unless $scope.myform.$valid
  , true
