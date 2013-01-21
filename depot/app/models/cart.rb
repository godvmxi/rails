class Cart
	attr_reader :items
	attr_reader :total_price
	def initialize
		@items = []
		@total_price = 0.0
	end
	def add_product(product) 
		@items << LineItem.for_product(product)
		@total_price += product.price
	end
end