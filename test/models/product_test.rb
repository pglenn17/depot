require 'test_helper'

class ProductTest < ActiveSupport::TestCase
	fixtures :products
  # test "the truth" do
  #   assert true
  # end

	test "product attributes must not be empty" do product = Product.new
		assert product.invalid?
		assert product.errors[:title].any?
		assert product.errors[:description].any?
		assert product.errors[:price].any?
  		assert product.errors[:image_url].any?
	end

	test "product price must be positive" do
		product = Product.new( 	title: "My book title",
								description: "My book description",
								image_url: "mybookimage.jpg" )
		product.price = -1
		assert product.invalid?
		assert_equal "must be greater than or equal to 0.01", 
			product.errors[:price].join('; ')

		product.price = 1
		assert product.valid?
		if Product.count == 0
			puts "count is zero"
		end
		Product.all.each do |product|
			puts product.title
		end
	end

	def new_product( image_url )
		product = Product.new( 	title: "My book title",
								description: "My book description",
								price: 1,
								image_url: image_url )
	end

	test "image url" do
		ok = %w{ test.jpg test.Jpg http://a.b.c/image/test.jpg test.GIF test.png }
		bad = %w{ test.jpg.more test test.doc }

		ok.each do |name|
			assert new_product( name ).valid?, "#{name} shouldn't be invalid"
		end

		bad.each do |name|
			assert new_product( name ).invalid?, "#{name} shouldn't be valid"
		end
	end

	test "product is not valid without a unique title" do
		product = Product.new(	:title => products(:ruby).title,
								:description => "yyy",
								:price => 1, 
								:image_url => "fred.gif" )
  		assert !product.save
		assert_equal "has already been taken", product.errors[:title].join('; ')
	end

	test "product description must be at least ten characters" do
		product = Product.new( 	description: "My book description",
								image_url: "myimageurl.jpg",
								price: 1 )
		15.times do |n|
			product.title = 'a' * n
			if n < 10
				assert product.invalid?
			else
				assert product.valid?
			end
		end
	end
end


