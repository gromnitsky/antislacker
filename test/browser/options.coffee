assert = require('chai').assert
expect = require('chai').expect

window.chrome = {
  runtime: {
    sendMessage: ->
  }
}

require '../../src/options'
u = require '../../src/utils'

load_def = ->
  raw = u.readFile '../db.localstorage'
  for key,val of JSON.parse(raw)
      localStorage.setItem key, val

describe 'Options', ->
  $scope = null

  before ->
    load_def()

  after ->
    localStorage.clear()

  beforeEach angular.mock.module('optionsApp')

  beforeEach angular.mock.inject ($rootScope, $controller) ->
    $scope = $rootScope.$new()
    $controller 'DomainCtrl', {$scope: $scope}

    # mock the form
    $scope.myform = { $valid: true }

    window.qqq = $scope

  it 'should create 3 table rows', ->
    expect($scope.domains.length).to.be.equal 3

  it 'should set the first row with "blog.example.com"', ->
    assert.deepEqual {
      "domain": 'blog.example.com'
      "enabled": true
      "limit": 15
      "elapsed": 0
      "lastupdated": 0
      "mutex": null
    }, $scope.domains[0]

  it 'should add 1 row', ->
    $scope.add()
    assert.equal $scope.domains.length, 4

  it 'should delete 1 row', ->
    $scope.rm 'facebook.com'
    assert.equal $scope.domains.length, 2

  it 'should not delete 1 row', ->
    $scope.rm "doesn't exists"
    assert.equal $scope.domains.length, 3
