require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
  # Your code goes here!
  @@data_path = File.dirname(__FILE__) + "/../data/data.csv"
   
  def self.create(attributes = nil)
    product = new(attributes)
    CSV.open(@@data_path, "a+b") do |productData|
      productData << [product.id, product.brand, product.name, product.price]
    end
    product
  end

  def self.all
    newProducts = []
    CSV.foreach(@@data_path, headers:true) do |product|
      id, brand, name, price = product["id"], product["brand"], product["product"], product["price"]
      newProducts << new(id: id, brand: brand, name: name, price: price)
    end
    newProducts
  end
  
  def self.first(index = 1)
    products = all
    if(index == 1)
      products.first
    else
      products.first(index)
    end
  end

  def self.last(index = 1)
    products = all
    if(index == 1)
      products.last
    else
      products.last(index)
    end
  end

  def self.find(index)
    products = all
    if(index > products.length)
      raise ProductNotFoundErrors, "'#{index}' out of range."
    products.each do |product|
      if(product.id == index)
        return product
      end
    end
  end

  def self.find_by_brand(brand)
    products = all
    products.each do |product|
      if(product.brand == brand)
        return product
      end
    end
  end

  def self.find_by_name(name)
    products = all
    products.each do |product|
      if(product.name == name)
        return product
      end
    end
  end

  def self.where(attributes = {})
    products = all
    productsByBrand = []

    if(attributes.keys[0] == :brand)
      products.each do |product|
        if(product.brand == attributes.values_at(:brand).join)
          productsByBrand << product
        end
      end
    elsif(attributes.keys[0] == :name)
      products.each do |product|
        if(product.name == attributes.values_at(:name).join)
          productsByBrand << product
        end
      end
    end
    productsByBrand
  end

  def update(attributes = {})
    @brand = attributes[:brand]
    @price = attributes[:price]
    cvsData = CSV.read(@@data_path)
    cvsData.delete_at(0)
    cvsData.each do |data|
      if(data[0].to_i == @id)
        data[1] = @brand
        data[3] = @price
      end
    end

    #create new dbs
    CSV.open(@@data_path, "wb") do |csv|
      csv << ["id", "brand", "product", "price"]
    end

    #append remaining data
    CSV.open(@@data_path, "a") do |csv|
      cvsData.each do |data|
        csv << [data[0], data[1], data[2], data[3]]
      end
    end
    self
  end

  def self.destroy(index)
    #read dbs and remove element
    cvsData = all
    deletedProduct = nil
    i = 0
    cvsData.each do |data|
      if(data.id == index)
        deletedProduct = data
        cvsData.delete_at(i)
      end
      i += 1
    end

    #create new dbs
    CSV.open(@@data_path, "wb") do |csv|
      csv << ["id", "brand", "product", "price"]
    end

    #append remaining data
    CSV.open(@@data_path, "a") do |csv|
      cvsData.each do |data|
        csv << [data.id, data.brand, data.name, data.price]
      end
    end
    deletedProduct
  end

  def self.update
  end

  
end
