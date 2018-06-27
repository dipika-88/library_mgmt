require 'rails_helper'

RSpec.describe Book, type: :model do

book = FactoryGirl.build(:book)  

 it "has a valid factory" do
    expect(book).to be_valid
  end

  describe Book do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:summary) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_presence_of(:quantity) }
  end
end