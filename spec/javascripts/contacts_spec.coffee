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

    it "allows us to cancel editing", ->
      @scope.showEditor(dummy)

      expect(@scope).toBeEditing()

      @scope.cancel()
      expect(@scope).not.toBeEditing()
      expect(@scope.contact).toEqual(dummy)

    describe "save", ->
      it "should save a new record", ->
        dummy = {full_name: "Bob Dylan", email: "bd@music.com"}
        @scope.save dummy

        @http.whenPOST("/api/contacts").respond(201, dummy)
        @http.flush();

        expect(@scope).toBeViewing()
        expect(@scope.contacts.length).toEqual 3

      it "should update an existing record", ->
        dummy = @scope.contacts[0]
        dummy.id = 7
        @scope.save dummy

        @http.whenPUT("/api/contacts/7").respond(204, dummy)
        @http.flush();

        expect(@scope).toBeViewing()
        expect(@scope.contacts.length).toEqual 2

    describe "capitalize", ->
      it "capitalizes string", ->
        expect(@scope.capitalize("my new name")).toEqual("My new name")

      it "ignores null", ->
        expect(@scope.capitalize(null)).toEqual("")

      it "ignores empty", ->
        expect(@scope.capitalize("")).toEqual("")

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

    it "can format dates", ->
      text = @scope.formatDate("1964-01-04")
      expect(text).toEqual("1/4/1964")

    describe "shows errors", ->
      it "on update w/o email", ->
        dummy = @scope.contacts[0]
        dummy.id = 7
        @scope.save dummy

        @http.whenPUT("/api/contacts/7").respond(422, {"errors": {"email": ["can't be blank"]}})
        @http.flush()

        expect(@scope).toBeEditing()
        expect(@scope.errorMessage).toEqual "Email can't be blank."

      it "on save w/o email", ->
        dummy = { "full_name": "Jimothy Halpert"}
        @scope.save dummy

        @http.whenPOST("/api/contacts").respond(422, {"errors": {"email": ["can't be blank"]}})
        @http.flush()

        expect(@scope).toBeEditing()
        expect(@scope.errorMessage).toEqual "Email can't be blank."
        expect(@scope.contacts.length).toEqual 2

