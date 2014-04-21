# README

## Setup With

- Ruby 2.1.1p76
- Rails 4.1.0
- Angular 1.3.0-beta.5
- RSpec / RSpecGiven / FactoryGirl

## Database Setup

- `rake db:migrate`
- `rake db:test:prepare` (though seems to be deprecated for 4.x)


## Run tests

- `rspec` - Rails tests
- `rake jasmine:ci` - JS tests

Alternatively, you can just run `rake jasmine` and open `localhost:8888` to view the jasmine specs.

## Notes

I chose to use the Angular framework for the front end for a number of reasons:

1. Simple two-way binding was desirable with the menu on the left and the contact page on the right. Keeping all the state for so many variables can get tricky.
2. Angular does service design very cleanly and makes it incredibly easy to write and test.
3. Rails `respond_to/with` makes sending the model data to angular's `$resource` services pretty much a one-liner for server and client-side integration.
4. Angular is a newer framework for me and this was a good problem to help me dig deeper.



