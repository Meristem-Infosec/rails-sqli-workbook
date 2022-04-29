class Product < ApplicationRecord
  has_many :order_products, dependent: :destroy
  has_many :orders, through: :order_products, dependent: :destroy
end
