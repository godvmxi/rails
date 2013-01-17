class StoreController < ApplicationController

  def index
  	@products = Product.salable_items
  end
end
