# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#   end

User.find_or_create_by!(email: 'admin@example.com') do |admin|
  admin.full_name = 'Administrator'
  admin.password = '123456'
  admin.role = :admin
end
puts "✅ Admin user ensured (Email: admin@example.com - Password: 123456)"
