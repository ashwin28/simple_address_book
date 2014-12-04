# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(name:  "Demo User", username: "demouser",
             password: "demouser", password_confirmation: "demouser")

15.times do |n|
  Contact.create(first_name: "Example", last_name: "User ##{n + 1}",
                 email: "ex_user_#{n + 1}@exu.com", phone: "123-1234-000#{n + 1}",
                 street: "#{n + 1} Sunny Lane", city: "Bolton", state: "Ontario",
                 zip: "L7E 2T#{n % 1}", country: "Canada", user_id: 1)
end
