class User < ApplicationRecord
  has_many :orders, dependent: :destroy 
  has_many :order_products, through: :orders, dependent: :destroy
  has_many :products, through: :order_products, dependent: :destroy
end