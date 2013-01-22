class Order < ActiveRecord::Base
	has_many :line_items
	PAYMENT_TYPES = [
	[ "Check", "check" ],
	[ "Credit Card", "cc" ],
	[ "Purchase Order", "po" ]
	].freeze
	validates_presence_of :name, :email, :address, :pay_type	
end
