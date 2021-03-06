require 'faker'
require 'csv'
require_relative 'schema'

# This file contains code that populates the database with
# fake data for testing purposes

def db_seed
  data_path = File.dirname(__FILE__) + "/data.csv"
  CSV.open(data_path, "a+") do |csv|
    10.times do |index|
      csv << [index+1, Faker::Company.name, Faker::Commerce.product_name, Faker::Commerce.price]
    end
  end
  
end
