class Cart
	attr_reader :items
	attr_reader :total_price
#	def initialize
#	@items = []
#		@total_price = 0.0
#	end
  	def initialize
		empty!
	end
	def add_product(product) 
#		@items << LineItem.for_product(product)
#		@total_price += product.price

		item = @items.find {|i| i.product_id == product.id}
		if item
			item.quantity += 1
		else
			item = LineItem.for_product(product)
			@items << item
		end
		@total_price += product.price
	end
	def empty!
	      @items = []
	      @total_price = 0.0
  	end

end
	
	