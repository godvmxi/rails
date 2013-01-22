class StoreController < ApplicationController

	def index
		@products = Product.salable_items
	end
	def add_to_cart
		product = Product.find(params[:id])
		@cart = find_cart
		@cart.add_product(product)
		redirect_to(:action => 'display_cart')
	rescue
	    logger.error("Attempt to access invalid product #{params[:id]}")
	    redirect_to_index('Invalid product')
	end

	def display_cart
		@cart = find_cart
		@items = @cart.items
		if @items.empty?
   			redirect_to_index("Your cart is currently empty")
   		end
	end

	def empty_cart
		find_cart.empty!
		flash[:notice] = 'Your cart is now empty'
		redirect_to(:action => 'index')
	end

	

	def empty_cart
		find_cart.empty!
		redirect_to_index('Your cart is now empty')
	end 

	def redirect_to_index(msg = null)
		flash[:notice] = msg
		redirect_to(:action => 'index')
	end


	def checkout
		@cart = find_cart
		@items = @cart.items
		if @items.empty?
			redirect_to_index("There's nothing in your cart!")
		else
			@order = Order.new
		end
	end


	private
	
	def find_cart
		session[:cart] ||= Cart.new
	end
end






