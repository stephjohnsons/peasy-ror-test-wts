require 'test_helper'
require 'sidekiq/testing'

class FetchProductDataJobTest < ActiveJob::TestCase
  test 'fetches and saves products to the database' do
    FetchProductDataJob.new.perform

    assert Product.first.name == 'MyString'
    assert Product.first.price == 9.99
  end
end
