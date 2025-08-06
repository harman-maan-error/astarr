# Simple version - replace your entire db/seeds.rb with this:

if Rails.env.development?
  puts "Clearing existing data..."
  OrderItem.destroy_all
  Order.destroy_all
  Review.destroy_all
  ProductImage.destroy_all
  Product.destroy_all
  Category.destroy_all
  Address.destroy_all
  User.destroy_all
  TaxRate.destroy_all
  SiteContent.destroy_all
end

puts "Creating tax rates..."
[
  { province: 'AB', rate: 0.05 }, { province: 'BC', rate: 0.12 }, { province: 'MB', rate: 0.12 },
  { province: 'NB', rate: 0.15 }, { province: 'NL', rate: 0.15 }, { province: 'NT', rate: 0.05 },
  { province: 'NS', rate: 0.15 }, { province: 'NU', rate: 0.05 }, { province: 'ON', rate: 0.13 },
  { province: 'PE', rate: 0.15 }, { province: 'QC', rate: 0.14975 }, { province: 'SK', rate: 0.11 },
  { province: 'YT', rate: 0.05 }
].each { |tax_data| TaxRate.create!(tax_data) }

puts "Creating categories..."
regular_category = Category.create!(
  name: "Astarr", slug: "astarr", description: "Premium quality iPhone cases with style and protection.",
  is_premium: false, price_multiplier: 1.0
)

premium_category = Category.create!(
  name: "Astarr Premium", slug: "astarr-premium", 
  description: "Luxury iPhone cases with premium materials and exclusive designs.",
  is_premium: true, price_multiplier: 1.35
)

puts "Creating users..."
admin = User.create!(
  email: "admin@astarr.com", password: "admin123", password_confirmation: "admin123",
  first_name: "Admin", last_name: "User", is_admin: true
)

john = User.create!(
  email: "john.doe@example.com", password: "password123", password_confirmation: "password123",
  first_name: "John", last_name: "Doe", phone: "416-555-0123"
)

jane = User.create!(
  email: "jane.smith@example.com", password: "password123", password_confirmation: "password123",
  first_name: "Jane", last_name: "Smith", phone: "647-555-0456"
)

puts "Creating addresses..."
Address.create!(user: john, street_address: "123 Main St", city: "Toronto", province: "ON", postal_code: "M5V 3A8", is_default: true)
Address.create!(user: jane, street_address: "456 Oak Ave", city: "Vancouver", province: "BC", postal_code: "V6B 1A1", is_default: true)

puts "Creating products..."

# Regular Products
counter = 1
products = []

[
  { name: 'Silicone Case', price: 29.99, material: 'Premium Silicone', desc: 'Soft-touch silicone provides comfortable grip and reliable protection.' },
  { name: 'Clear Case', price: 24.99, material: 'Clear TPU', desc: 'Crystal clear protection that showcases your iPhone design.' },
  { name: 'Leather Case', price: 49.99, material: 'Genuine Leather', desc: 'Genuine leather case that develops a beautiful patina over time.' },
  { name: 'Tough Case', price: 39.99, material: 'Polycarbonate + TPU', desc: 'Maximum protection for active lifestyles and demanding environments.' }
].each do |case_type|
  ['iPhone 15 Pro Max', 'iPhone 15 Pro', 'iPhone 14 Pro Max', 'iPhone 14 Pro'].each do |model|
    ['Midnight Black', 'Arctic White'].each do |color|
      product = Product.create!(
        name: case_type[:name],
        slug: "#{case_type[:name].parameterize}-#{model.parameterize}-#{color.parameterize}-#{counter}",
        description: case_type[:desc],
        specifications: 'Drop protection, Wireless charging compatible, Precise cutouts',
        base_price: case_type[:price],
        category: regular_category,
        iphone_model: model,
        color: color,
        material: case_type[:material],
        stock_quantity: rand(10..50),
        is_featured: counter <= 8,
        is_on_sale: counter % 5 == 0,
        sale_price: counter % 5 == 0 ? case_type[:price] * 0.8 : nil,
        active: true
      )
      products << product
      counter += 1
    end
  end
end

# Premium Products
[
  { name: 'Carbon Fiber Case', price: 79.99, material: 'Carbon Fiber', desc: 'Aerospace-grade carbon fiber for ultimate protection and style.' },
  { name: 'Titanium Case', price: 149.99, material: 'Grade 5 Titanium', desc: 'Precision-machined titanium case for the discerning user.' }
].each do |case_type|
  ['iPhone 15 Pro Max', 'iPhone 15 Pro', 'iPhone 14 Pro Max'].each do |model|
    ['Platinum', 'Obsidian'].each do |color|
      product = Product.create!(
        name: case_type[:name],
        slug: "premium-#{case_type[:name].parameterize}-#{model.parameterize}-#{color.parameterize}-#{counter}",
        description: case_type[:desc],
        specifications: 'Premium materials, Lifetime warranty, Exclusive design',
        base_price: case_type[:price],
        category: premium_category,
        iphone_model: model,
        color: color,
        material: case_type[:material],
        stock_quantity: rand(5..20),
        is_featured: true,
        is_on_sale: false,
        active: true
      )
      products << product
      counter += 1
    end
  end
end

puts "Creating reviews..."
review_data = [
  { title: "Love this case!", comment: "This case fits my phone perfectly and the color is exactly as shown. Great quality!", rating: 5 },
  { title: "Great protection", comment: "I've dropped my phone several times and this case has protected it every time.", rating: 5 },
  { title: "Perfect fit", comment: "The material feels premium and the cutouts are precise. Wireless charging works perfectly.", rating: 4 },
  { title: "Excellent quality", comment: "Beautiful case that looks great and provides excellent protection. Worth every penny.", rating: 5 }
]

products.sample(15).each do |product|
  review = review_data.sample
  Review.create!(
    product: product,
    user: [john, jane].sample,
    rating: review[:rating],
    title: review[:title],
    comment: review[:comment],
    verified_purchase: true,
    approved: true
  )
end

puts "Creating site content..."
[
  { page_name: 'home', section: 'hero_title', content: 'Premium iPhone Cases by Astarr' },
  { page_name: 'home', section: 'hero_subtitle', content: 'Protect your iPhone in style with our collection of premium cases' },
  { page_name: 'about', section: 'main_content', content: '<h2>About Astarr</h2><p>Founded with a passion for design and protection, Astarr creates premium iPhone cases that combine style, functionality, and durability.</p>' },
  { page_name: 'contact', section: 'main_content', content: '<h2>Contact Us</h2><p><strong>Customer Service</strong><br>Email: support@astarr.com<br>Phone: 1-800-ASTARR-1</p>' }
].each { |content_data| SiteContent.create!(content_data) }

puts "Seeding completed successfully!"
puts "Created:"
puts "- #{Category.count} categories"
puts "- #{User.count} users (including 1 admin)"
puts "- #{Product.count} products"
puts "- #{Review.count} reviews"
puts "- #{TaxRate.count} tax rates"
puts "- #{SiteContent.count} site content entries"
puts ""
puts "Admin login: admin@astarr.com / admin123"
puts "Customer login: john.doe@example.com / password123"