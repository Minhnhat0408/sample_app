# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
def remove_diacritics(str)
  Unicode.normalize_KD(str).gsub(/[^a-zA-Z0-9\-.]/, '')
end



User.create!(name: "MinhMatMong",
            email: ENV["ADMIN_EMAIL"],
            password: ENV["ADMIN_PASSWORD"],
            password_confirmation: ENV["ADMIN_PASSWORD"],
            admin: true)


# Create 30 fake users
30.times do |n|
  name = Faker::Name.name
  cleaned_name = remove_diacritics(name).downcase
  email = "#{cleaned_name}@gmail.com"
  password = "password"
  User.create!(name: name,
              email: email,
              password: password,
              password_confirmation: password)
end
