class StoreController < ApplicationController

  def index
  	@products = Product.salable_items
  end
  def add_to_cart
		product = Product.find(params[:id])
		@cart = find_cart
		@cart.add_product(product)
		redirect_to(:action => 'display_cart')
	end
  private
	def find_cart
		session[:cart] ||= Cart.new
	end
end
