# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Contact.create([
  {
    name: "Doug Stamper",
    sex: "male",
    age: 50,
    birthday: "4/1/1964",
    address: {
      street: "77 Main St",
      city: "Washington",
      state: "DC",
      postcode: 20004
    },
    phone: "555-555-5555",
    email: "thestamper@hotmail.com"
  },
  {
    name: "Francis Underwood",
    sex: "male",
    age: 54,
    birthday: "11/5/1959",
    address: {
      street: "123 Anywhere",
      city: "Washington",
      state: "DC",
      postcode: 20004
    },
    phone: "555-555-5555",
    email: "littlejohn@whitehouse.gov"
  },
  {
    name: "Zoey Barnes",
    sex: "female",
    age: 27,
    birthday: "3/25/1987",
    address: {
      street: "456 Somewhere Else",
      city: "Annapolis",
      state: "MD",
      postcode: 21401
    },
    phone: "555-555-5555",
    email: "zbarnes@slugline.com"
  }
])