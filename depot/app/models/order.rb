class Order < ActiveRecord::Base
	has_many :line_items
	PAYMENT_TYPES = [
	[ "Check", "check" ],
	[ "Credit Card", "cc" ],
	[ "Purchase Order", "po" ]
	].freeze
end
