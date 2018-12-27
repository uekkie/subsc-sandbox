
# User.destroy_all

# Create dummy users
# Male
users = []
password = "password"

50.times do |no|
  gimei = Gimei.male
  users << User.new(
    name: gimei.kanji,
    email: Faker::Internet.email,
    password: password,
    password_confirmation: password
  )
end


50.times do |no|
  gimei = Gimei.female
  users << User.new(
    name: gimei.kanji,
    email: Faker::Internet.email,
    password: password,
    password_confirmation: password
  )
end

# Bulk insert
User.import users
