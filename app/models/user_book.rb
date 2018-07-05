# == Schema Information
#
# Table name: user_books
#
#  id          :bigint(8)        not null, primary key
#  user_id     :bigint(8)
#  book_id     :bigint(8)
#  issue_date  :datetime
#  return_date :datetime
#  status      :integer          default("issued")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class UserBook < ApplicationRecord
  belongs_to :user
  belongs_to :book
  validate :books_quantity, on: :create, if: :book
  before_update :update_book_status
  after_commit  :update_books_count, on: [:create, :update]
  enum status: [:issued, :returned]

  def update_book_status
    self.return_date = Time.now
    self.status = 1
  end

  def update_books_count
    if returned?
      book.increment!(:quantity)
    else
      book.decrement!(:quantity)
    end
  end

  def books_quantity
    errors.add(:base, 'Book is not available.') if book.quantity < 1
  end
end
