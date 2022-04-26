class User < ApplicationRecord
  has_many :orders, dependent: :delete_all, foreign_key: :trackable_id
  has_many :order_products, through: :order, dependent: :delete_all, foreign_key: :trackable_id
  has_many :products, through: :order_products, dependent: :delete_all, foreign_key: :trackable_id
end