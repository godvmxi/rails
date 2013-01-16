class Product < ActiveRecord::Base
  validates_presence_of :title, :description, :image_url
  validates_numericality_of :price
  validates_uniqueness_of :title
  validates_format_of :image_url,
        :with => %r{^http:.+\.(gif|jpg|png)$}i,
        :message => "must be a URL for a GIF, JPG, or PNG image"
  protected
    def validate
      errors.add(:price, "should be positive") unless price.nil? || price > 0.0
    end
end