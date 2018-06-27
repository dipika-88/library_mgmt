# == Schema Information
#
# Table name: books
#
#  id          :bigint(8)        not null, primary key
#  name        :string
#  summary     :text
#  quantity    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  price       :decimal(8, 2)
#  cover_image :string
#

class Book < ApplicationRecord
  mount_uploader :cover_image, ImageUploader
  
  validates_presence_of :name, :summary, :quantity, :price

  has_many :user_books, dependent: :destroy
  has_many :users, through: :user_books
end
