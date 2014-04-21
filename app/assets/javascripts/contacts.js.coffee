#= require "moment.min"
#= depend_on_asset "editor.html"
#= depend_on_asset "editable_field.html"

ContactApp = angular.module('ContactApp', ['ngResource'])
DATE_FORMAT = "M/D/YYYY"

ContactApp.config ($httpProvider) ->
  authToken = $("meta[name=\"csrf-token\"]").attr("content")
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken

ContactApp.factory 'Contacts', ($resource) ->
    @service = $resource '/api/contacts/:id',
      {id: '@id'}
      update: { method: 'PUT' }

ContactApp.controller 'ContactControl', ($scope, Contacts) ->
  $scope.init = ->
    $scope.viewing = false
    $scope.editing = false
    $scope.contacts = Contacts.query()

  $scope.capitalize = (str) ->
    return "" unless angular.isString(str)
    str.charAt(0).toUpperCase() + str.slice(1)

  formatErrors = (errors) ->
    all = for field, error of errors.errors
      "#{$scope.capitalize(field)} #{error}."

    all.join("<br/>")

  $scope.sexes = [
    { name: "Male", value: "male" }
    { name: "Female", value: "female" }
  ]

  $scope.displayErrors = (response) ->
    $scope.errorMessage = formatErrors(response.data)
    $scope.editing = true
    $scope.viewing = false

  $scope.newContact = ->
    $scope.showEditor()

  $scope.save = (contact) ->
    # normalize birthday for rails
    $scope.clearErrors()

    saved = if contact.id
      contact.$update {},
        ->
          $scope.contact = contact
          $scope.showContact(contact)
        $scope.displayErrors
    else
      newContact = new Contacts(contact)
      newContact.$save {},
        (c) ->
          $scope.contacts.push c
          $scope.showContact(c)
        $scope.displayErrors

  $scope.clearErrors = ->
    $scope.errorMessage = null

  $scope.showEditor = (contact) ->
    $scope.viewing = false
    $scope.editing = true
    $scope.contact = contact

  $scope.showContact = (contact) ->
    $scope.viewing = true
    $scope.editing = false
    $scope.contact = contact

  $scope.truncate = (string, max) ->
    return string if string.length <= max
    string.substring(0, max-3) + "..."

  $scope.formatDate = (date) ->
    return if date == "" || date == null
    moment(date).format(DATE_FORMAT)

ContactApp.directive 'editor', () ->
  restrict: 'E',
  templateUrl: '/assets/editor.html'

ContactApp.directive 'birthdayField', () ->
  require: '^ngModel'
  transclude: false
  restrict: 'C'
  link: (scope, elm, attrs, ctrl) ->
    attrs.$observe 'birthdayField', (newValue) ->
      ctrl.$modelValue = new Date(ctrl.$setViewValue)

    ctrl.$formatters.unshift (modelValue) ->
      return "" unless modelValue
      moment(modelValue).format(DATE_FORMAT)

    ctrl.$parsers.unshift (viewValue) ->
      date = moment(viewValue)
      if (date && date.isValid()) then date.toDate() else ""

ContactApp.directive 'editableField', ($compile) ->
  require: '^ngModel'
  restrict: "E"
  templateUrl: "/assets/editable_field.html"
  scope:
    ngModel: '='
    size: "@"
    placeholder: "@"
    id: "@"