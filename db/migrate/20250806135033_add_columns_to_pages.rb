class AddColumnsToPages < ActiveRecord::Migration[7.0]
  def change
    add_column :pages, :slug, :string, null: false
    add_column :pages, :title, :string, null: false
    add_column :pages, :content, :text
    add_column :pages, :meta_description, :text
    add_column :pages, :meta_keywords, :string
    add_column :pages, :published, :boolean, default: true
    
    add_index :pages, :slug, unique: true
    add_index :pages, :published
    
    # Seed the pages after adding columns
    reversible do |dir|
      dir.up do
        Page.create!([
          {
            slug: 'about',
            title: 'About Us',
            content: '<p>Welcome to Astarr. We are dedicated to providing excellent service and quality products.</p><p>Our team is committed to customer satisfaction and continuous improvement.</p>',
            meta_description: 'Learn more about our company and mission',
            published: true
          },
          {
            slug: 'contact',
            title: 'Contact Us',
            content: '<p>Get in touch with us for any inquiries or support.</p><h3>Contact Information</h3><p><strong>Email:</strong> info@astarr.com<br><strong>Phone:</strong> (555) 123-4567<br><strong>Address:</strong> 123 Business St, Suite 100<br>Business City, BC 12345</p><h3>Business Hours</h3><p>Monday - Friday: 9:00 AM - 6:00 PM<br>Saturday: 10:00 AM - 4:00 PM<br>Sunday: Closed</p>',
            meta_description: 'Contact information and ways to reach us',
            published: true
          },
          {
            slug: 'shipping',
            title: 'Shipping Information',
            content: '<p>Learn about our shipping policies and delivery options.</p><h3>Shipping Methods</h3><p>We offer several shipping options to meet your needs:</p><ul><li><strong>Standard Shipping (5-7 business days)</strong> - Free on orders over $50</li><li><strong>Express Shipping (2-3 business days)</strong> - $15.99</li><li><strong>Overnight Shipping (1 business day)</strong> - $29.99</li></ul><h3>Processing Time</h3><p>Orders are typically processed within 1-2 business days.</p>',
            meta_description: 'Shipping information and delivery options',
            published: true
          },
          {
            slug: 'returns',
            title: 'Returns & Refunds',
            content: '<p>Our return policy ensures your satisfaction with every purchase.</p><h3>Return Policy</h3><p>You may return most items within 30 days of delivery for a full refund.</p><ul><li>Items must be in original condition</li><li>Original packaging required</li><li>Return shipping costs apply</li></ul><h3>How to Return</h3><p>Contact our customer service team to initiate a return.</p>',
            meta_description: 'Return and refund policy information',
            published: true
          }
        ])
      end
    end
  end
end