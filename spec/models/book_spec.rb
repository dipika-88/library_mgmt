require 'rails_helper'
RSpec.describe Book, type: :model do
  it 'has a valid factory' do
    book = FactoryGirl.build(:book)
    expect(book).to be_valid
  end
  describe Book, 'column_specification' do
    it { should have_db_column(:name).of_type(:string).with_options(presence: true) }
    it { should have_db_column(:summary).of_type(:text).with_options(presence: true) }
    it { should have_db_column(:quantity).of_type(:integer).with_options(numericality: true) }
    it { should have_db_column(:price).of_type(:decimal).with_options(numericality: true) }
  end
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:summary) }
    it { is_expected.to validate_length_of(:summary) }
    it { is_expected.to validate_numericality_of(:quantity) }
    it { is_expected.to validate_numericality_of(:price) }
  end
  describe 'associations' do
    it { should have_many(:user_books).dependent(:destroy) }
    it { should have_many(:users).through(:user_books) }
  end
end