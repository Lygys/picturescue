# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

5.times do |n|
  User.create!(
    email: "test_user#{n + 1}@gmail.com",
    name: "test_user#{n + 1}",
    password: "testtest"
  )
end



Admin.create!(
   email: 'test_admin@gmail.com',
   password: "testtest"
)