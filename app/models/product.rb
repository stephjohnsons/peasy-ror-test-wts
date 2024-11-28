class Product < ApplicationRecord
  before_save :format_price

  private

  def format_price
    if self.price.present?
      self.price = BigDecimal(self.price.to_s).round(2).to_s
    end
  end
end
