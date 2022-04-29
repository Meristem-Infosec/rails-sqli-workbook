class Order < ApplicationRecord
  belongs_to :user
  has_many :order_products, dependent: :destroy
  has_many :products, through: :order_products, dependent: :destroy
end
