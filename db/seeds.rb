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
            admin: true,
            activated: true,
            activated_at: Time.zone.now)


# Create 30 fake users
30.times do |n|
  name = Faker::Name.name
  cleaned_name = remove_diacritics(name).downcase
  email = "#{cleaned_name}@gmail.com"
  password = "password"
  User.create!(name: name,
              email: email,
              password: password,
              password_confirmation: password,
              activated: true,
              activated_at: Time.zone.now)
end


users = User.order(:created_at).take(6)

30.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.microposts.create!(content: content) }
end

users = User.all
user = users.first
following = users[2..20]
followers = users[3..15]
following.each{|followed| user.follow(followed)}
followers.each{|follower| follower.follow(user)}
