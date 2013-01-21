class LineItem < ActiveRecord::Base
	belongs_to :product
	def self.for_product(product) self.new
		item = self.new
		item.quantity = 1
		item.product = product
		item.unit_price = product.price
		item
	end

end
