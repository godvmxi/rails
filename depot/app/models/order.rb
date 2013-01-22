class Order < ActiveRecord::Base
	has_many :line_items
	PAYMENT_TYPES = [
	[ "Check", "check" ],
	[ "Credit Card", "cc" ],
	[ "Purchase Order", "po" ]
	].freeze
	validates_presence_of :name, :email, :address, :pay_type	

	def self.pending_shipping
    	find(:all, :conditions => "shipped_at is null")
	end
	def mark_as_shipped
   		self.shipped_at = Time.now
 	end
end
