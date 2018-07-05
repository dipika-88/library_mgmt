require 'rails_helper'
RSpec.describe User, type: :model do
  describe 'constants' do
    it { expect(User::ROLES).to eq(['user', 'admin', 'administrator']) }
  end
  it 'define role enums' do
    should define_enum_for(:role).with([:user, :admin, :administrator])
  end
  describe User, 'column_specification' do
    it { should have_db_column(:name).of_type(:string).with_options(presence: true) }
    it { should have_db_column(:email).of_type(:string).with_options(presence: true) }
  end
  describe 'validations' do
    it 'has a valid factory' do
      user = FactoryGirl.build(:user)
      expect(user).to be_valid
    end
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
  end
  describe 'associations' do
    it { should have_many(:user_books).dependent(:destroy) }
    it { should have_many(:books).through(:user_books) }
  end
  describe 'instance methods' do
    describe '#has_role?' do
      let(:user) { FactoryGirl.create(:user) }
      context 'when user has requested role' do
        it 'return true' do
          expect(user.role?('user')).to be_truthy
        end
      end
      context 'when user does not have requested role' do
        it 'returns false' do
          expect(user.role?('admin')).to be_falsy
        end
      end
    end
  end
end
