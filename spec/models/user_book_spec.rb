require 'rails_helper'
RSpec.describe UserBook, type: :model do
  it 'define enums' do
    should define_enum_for(:status).with([:issued, :returned])
  end
  describe UserBook, 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:book) }
  end
  describe UserBook, 'column_specification' do
    it { should have_db_column(:user_id).of_type(:integer).with_options(presence: true) }
    it { should have_db_column(:book_id).of_type(:integer).with_options(presence: true) }
  end
  describe 'callbacks' do
    it { is_expected.to callback(:books_quantity).before(:validate) }
    it { is_expected.to callback(:update_book_status).before(:update) }
    it { is_expected.to callback(:update_books_count).after(:commit) }
    describe 'update_books_count' do
      let(:user_book) { FactoryGirl.build(:user_book) }
      it 'is expected to decrement the books count when book is issued' do
        expect { user_book.save }.to change { user_book.book.quantity }.by(-1)
      end
      it 'is expected to update status and return date and decrement the books count' do
        expect { user_book.update(return_date: Time.now, status: 1) }.to change { user_book.book.quantity }.by(1)
      end
    end
  end
end
