#= require spec_helper

describe "ContactControl", ->
  contacts = []

  beforeEach ->
    @controller('ContactControl', { $scope: @scope })
    @Contact = @model('Contacts')

    contacts.push new @Contact({full_name: "Busta Move"})
    contacts.push new @Contact({full_name: "Sound Fury"})

    @scope.init()

    @http.whenGET('/api/contacts').respond(200, @contacts)
    @http.flush()

  describe "controller", ->
    it "should show a landing page first", ->
      expect(@scope.viewing).toBe false
      expect(@scope.editing).toBe false

    it "shows the selected contact", ->
      dummy = contacts[0]
      @scope.showContact(dummy)

      expect(@scope.viewing).toBe true
      expect(@scope.editing).toBe false
      expect(@scope.contact).toEqual dummy

    it "allows the contact to be edited", ->
      dummy = contacts[1]
      @scope.showEditor(dummy)

      expect(@scope.viewing).toBe false
      expect(@scope.editing).toBe true
      expect(@scope.contact).toEqual dummy