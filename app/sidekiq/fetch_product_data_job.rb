require 'sidekiq'
require 'httparty'

class FetchProductDataJob
  include Sidekiq::Job

  def perform(number_of_products = nil)
    if number_of_products.nil?
      url = "https://fakestoreapi.com/products"
    else
      url = "https://fakestoreapi.com/products/#{number_of_products}"
    end

    response = HTTParty.get(url)

    if response.success?
      products = response.parsed_response

      # Prepare product data
      product_data = products.map do |product|
        {
          name: product['title'],
          price: product['price'].to_f
        }
      end

      # Insert new products if they don't already exist by name
      product_data.each do |data|
        # Check if the product title already exists
        unless Product.exists?(name: data[:name])
          Product.create(data)
        end
      end

      Rails.logger.info("Successfully fetched and saved #{product_data.size} products.")
    else
      Rails.logger.error("Failed to fetch products: #{response.code} #{response.message}")
    end
  end
end
