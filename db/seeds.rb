# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Users
10.times do
  first_name = Faker::Name.first_name
  User.create(
    first_name: first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email(name: first_name),
    pw_hash: Faker::Internet.password(min_length: 10, mix_case: true)
  )
end
u = User.first
u.attributes = {is_admin: true}
u.save
puts User.inspect

# Products
10.times do
  search_term = Faker::Appliance.equipment 
  name = (Faker::Hacker.adjective + ' ' + Faker::Hipster.word + ' ' + search_term).titleize
  Product.create(
    name: name,
    image_url: Faker::LoremFlickr.image(size: "200x200", search_terms: [search_term.split(' ').last]),
    cost: Faker::Number.decimal(l_digits: 2)
  )
end

# Orders
2.times do
  User.all.each do | user |
    Order.create(
      user_id: user.id,
      credit_card: Faker::Finance.credit_card
    )
  end
end

# Order Products
2.times do
  Order.all.each do | order |
    OrderProduct.create(
      order_id: order.id,
      product_id: Product.order(Arel.sql('RANDOM()')).first.id,
      quantity: rand(1..10)
    )
  end
end