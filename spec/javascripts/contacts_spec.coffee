#= require spec_helper

describe "ContactControl", ->
  beforeEach ->
    jasmine.addMatchers
      toBeViewing: ->
        compare: (scope) ->
          pass: scope.viewing == true && scope.editing == false
      toBeEditing: ->
        compare: (scope) ->
          pass: scope.viewing == false && scope.editing == true

  beforeEach ->
    @controller('ContactControl', { $scope: @scope })
    @Contact = @model('Contacts')

    @contacts = []
    @contacts.push(new @Contact({full_name: "Busta Move"}))
    @contacts.push(new @Contact({full_name: "Sound Fury"}))

    @scope.init()

    @http.whenGET('/api/contacts').respond(200, @contacts)
    @http.flush()

  describe "controller", ->
    it "should show a landing page first", ->
      expect(@scope.viewing).toBe false
      expect(@scope.editing).toBe false

    it "shows the selected contact", ->
      dummy = @scope.contacts[0]
      @scope.showContact(dummy)

      expect(@scope).toBeViewing()
      expect(@scope.contact).toEqual dummy

    it "allows the contact to be edited", ->
      dummy = @scope.contacts[1]
      @scope.showEditor(dummy)

      expect(@scope).toBeEditing()
      expect(@scope.contact).toEqual dummy

    describe "truncate", ->
      dummy = null
      beforeEach ->
        dummy = @scope.contacts[0]

      it "don't bother strings under length", ->
        text = @scope.truncate(dummy.full_name, 100)
        expect(text).toEqual(dummy.full_name)

      it "size with ellipses", ->
        text = @scope.truncate(dummy.full_name, 5)

        expect(text.length).toEqual(5)
        expect(text).toEqual("Bu...")



