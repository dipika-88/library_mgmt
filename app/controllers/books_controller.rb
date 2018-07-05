# This is used to manage books in library
class BooksController < ApplicationController
  load_and_authorize_resource
  before_action :load_book, except: [:index, :new, :create]

  def index
    @books = Book.all
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to books_url, notice: 'Book successfully created.'
    else
      render :new
    end
  end

  def update
    if @book.update_attributes(book_params)
      redirect_to books_url, notice: 'Book successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @book.destroy
      redirect_to books_url, notice: 'Book successfully deleted.'
    else
      redirect_to books_url, notice: 'Not possible to destroy the Book.'
    end
  end

  private

  def book_params
    params.require(:book).permit(:id, :name, :summary, :quantity, :cover_image, :author)
  end

  def load_book
    @book = Book.find(params[:id])
  end
end
