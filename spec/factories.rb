# This will guess the User class
FactoryGirl.define do
  factory :contact do
    first_name "John"
    last_name  "Doe"
    street "70 Sugar Maple St."
    city "Bluffton"
    state "SC"
    zip 29910
    sex 25
    birthday 15.years.ago
    phone "843-321-9507"
    sequence :email do |n|
     "#{first_name}.#{n}@test.com".downcase
   end
 end
end