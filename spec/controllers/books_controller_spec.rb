require 'rails_helper'
RSpec.describe BooksController, type: 'controller' do
  shared_examples_for :load_book do |type, action|
    describe 'Before action' do
      it 'load before action' do
        send(type, action, params: { id: @book.id })
        is_expected.to use_before_action(:load_book)
      end
      it 'assign book' do
        send(type, action, params: { id: @book.id })
        expect(assigns(:book)).to eq(@book)
      end
    end
  end
  before do
    allow(controller).to receive(:configure_permitted_parameters)
    allow_any_instance_of(CanCan::ControllerResource).to receive(:load_resource)
    allow_any_instance_of(CanCan::ControllerResource).to receive(:authorize_resource)
  end
  describe 'GET index' do
    before do
      @book = FactoryGirl.create(:book)
      allow(Book).to receive(:all).and_return([@book])
    end
    it 'has a 200 status code' do
      get :index
      expect(response.status).to eq(200)
    end
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
    it 'assigns @books' do
      get :index
      expect(assigns(:books)).to eq([@book])
    end
  end
  describe 'GET new book' do
    it 'assigns a new book to the view' do
      get :new
      expect(assigns(:book)).to be_a_new(Book)
    end
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end
  describe 'CREATE a Book' do
    before do
      @book = FactoryGirl.build(:book)
      allow(Book).to receive(:new).and_return(@book)
      allow(controller).to receive(:book_params).and_return({})
    end

    context 'when book is created' do
      before do
        allow(@book).to receive(:save).and_return(true)
      end
      it 'redirects to books listing' do
        post :create
        expect(response).to redirect_to(books_path)
      end
    end
    context 'when book is not created' do
      before do
        allow(@book).to receive(:save).and_return(false)
      end
      it 'render a new book template' do
        post :create
        expect(response).to render_template(:new)
      end
    end
  end
  describe 'UPDATE Book' do
    before do
      @book = FactoryGirl.create(:book)
      allow(Book).to receive(:find).and_return(@book)
      allow(controller).to receive(:book_params).and_return({})
    end
    it_behaves_like :load_book, :put, :update
    context 'when book is updated' do
      before do
        allow(@book).to receive(:update_attributes).and_return(true)
      end
      it 'redirects to books listing' do
        put :update, params: { id: @book.id }
        expect(response).to redirect_to(books_path)
      end
    end

    context 'when book is not updated' do
      before do
        allow(@book).to receive(:update_attribute).and_return(false)
      end
      it 'render edit book template' do
        get :edit, params: { id: @book.id }
        expect(response).to render_template(:edit)
      end
    end
  end
  describe 'DESTROY a Book' do
    it_behaves_like :load_book, :delete, :destroy
    before do
      @book = FactoryGirl.create(:book)
      allow(Book).to receive(:find).and_return(@book)
    end
    context 'when book is deleted' do
      before do
        allow(@book).to receive(:destroy).and_return(true)
      end
      it 'redirects to listing with a flash message' do
        delete :destroy, params: { id: @book.id }
        expect(response).to redirect_to(books_path)
        expect(flash[:notice]).to eq 'Book successfully deleted.'
      end
    end
    context 'when book is not deleted' do
      before do
        allow(@book).to receive(:destroy).and_return(false)
      end
      it 'redirects to listing with a flash message' do
        delete :destroy, params: { id: @book.id }
        expect(response).to redirect_to(books_path)
        expect(flash[:notice]).to eq 'Not possible to destroy the Book.'
      end
    end
  end
end
