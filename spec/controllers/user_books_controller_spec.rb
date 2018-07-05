require 'rails_helper'
RSpec.describe UserBooksController, type: 'controller' do
  let(:default_param) { { id: 1 } }
  shared_examples_for :set_user_book do |type, action|
    describe 'Before action' do
      it 'load before action' do
        send(type, action, params: { id: @user_book.id })
        is_expected.to use_before_action(:set_user_book)
      end
      it 'assign book' do
        send(type, action, params: { id: @user_book.id })
        expect(assigns(:user_book)).to eq(@user_book)
      end
    end
  end
  before do
    allow(controller).to receive(:configure_permitted_parameters)
    allow_any_instance_of(CanCan::ControllerResource).to receive(:load_resource)
    allow_any_instance_of(CanCan::ControllerResource).to receive(:authorize_resource)
    @user = FactoryGirl.create(:user)
    allow(controller).to receive(:current_user).and_return(@user)
    @user_book = FactoryGirl.create(:user_book)
  end
  describe 'GET index' do
    before do
      @books = FactoryGirl.create(:book)
      allow(@user).to receive_message_chain(:user_books, :all).and_return(@books)
    end
    it 'has a 200 status code' do
      get :index
      expect(response.status).to eq(200)
    end
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
    it 'assigns @user_books' do
      get :index
      expect(assigns(:user_books)).to eq(@books)
    end
  end
  describe 'GET new user book' do
    it 'assigns a blank user book to the view' do
      get :new
      expect(assigns(:user_book)).to be_a_new(UserBook)
    end
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end
  describe 'POST create user book' do
    before do
      @user_book = FactoryGirl.build(:user_book)
      allow(UserBook).to receive(:new).and_return(@user_book)
      allow(controller).to receive(:user_book_params).and_return(@user_book)
    end
    context 'when book is issued successfully' do
      before do
        allow(@user_book).to receive(:save).and_return(true)
      end
      it 'redirects to listings' do
        post :create
        expect(response).to redirect_to(user_books_path)
      end
    end
    context 'when book is not issued' do
      before do
        allow(@user_book).to receive(:save).and_return(false)
      end
      it 'render a new template' do
        post :create
        expect(response).to render_template(:new)
      end
    end
  end
  describe 'GET show user book' do
    before do
      allow(@user).to receive_message_chain(:user_books, :find_by).and_return(@user_book)
    end
    it_behaves_like :set_user_book, :get, :show
    it 'has a 200 status code' do
      get :show, params: { id: default_param }
      expect(response.status).to eq(200)
    end
    context 'show detail page' do
      it 'enders the #show view' do
        get :show, params: { id: default_param }
        expect(response).to render_template(:show)
      end
    end
  end
  describe 'EDIT user book' do
    before do
      allow(@user).to receive_message_chain(:user_books, :find_by).and_return(@user_book)
    end
    it_behaves_like :set_user_book, :get, :edit
    context 'when book is already returned' do
      before do
        allow(@user_book).to receive(:returned?).and_return(true)
      end
      it 'redriects to listings' do
        get :edit, params: { id: @user_book.id }
        expect(response).to redirect_to(user_books_path)
      end
    end
    context 'render edit template' do
      before do
        allow(@user_book).to receive(:returned?).and_return(false)
      end
      it 'return status 200' do
        get :edit, params: { id: @user_book.id }
        expect(response.status).to eq(200)
      end
    end
  end
  describe 'UPDATE user book' do
    before do
      allow(controller).to receive(:user_book_params).and_return({})
      allow(@user).to receive_message_chain(:user_books, :find_by).and_return(@user_book)
    end
    it_behaves_like :set_user_book, :put, :update
    context 'when user book is updated' do
      before do
        allow(@user_book).to receive(:update).and_return(true)
      end
      it 'redirects to detail page' do
        put :update, params: { id: @user_book.id }
        expect(response).to redirect_to(user_book_path(@user_book))
      end
    end
    context 'when user book is not updated' do
      before do
        allow(@user_book).to receive(:update).and_return(false)
      end
      it 'redirects to edit template' do
        get :edit, params: { id: @user_book.id }
        expect(response).to render_template(:edit)
      end
    end
  end
  describe 'Delete user book' do
    before do
      allow(controller).to receive(:user_book_params).and_return({})
      allow(@user).to receive_message_chain(:user_books, :find_by).and_return(@user_book)
    end
    it_behaves_like :set_user_book, :put, :update
    context 'when user book is deleted' do
      before do
        allow(@user_book).to receive(:destroy).and_return(true)
      end
      it 'redriects to listings with a flash message' do
        delete :destroy, params: { id: @user_book.id }
        expect(response).to redirect_to(user_books_path)
        expect(flash[:notice]).to eq 'User Book history was successfully deleted.'
      end
    end
    context 'when user book is not deleted' do
      before do
        allow(@user_book).to receive(:destroy).and_return(false)
      end
      it 'redirects to listing with a flash message' do
        delete :destroy, params: { id: @user_book.id }
        expect(response).to redirect_to(user_books_path)
        expect(flash[:notice]).to eq 'Not possible to destroy the User Book.'
      end
    end
  end
end
