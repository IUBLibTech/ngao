# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
%w[jlhardes@iu.edu rdfloyd@iu.edu acrande@iu.edu rob@notch8.com].each do |email|
  user = User.where(email: email).first_or_create do |u|
    u.password = 'testing123'
    u.role = 'admin'
  end
end
