class UserBooksController < ApplicationController
	load_and_authorize_resource
  before_action :set_user_book, only: [:show, :edit, :update, :destroy]

  def index
    @user_books = current_user.user_books.all
  end

  def show
  end


  def new
    @user_book = current_user.user_books.new
  end

  def edit
     if  @user_book.returned? 
        flash[:alert] = "Invalid Request"
        redirect_to user_books_path
      end
  end

  def create
    @user_book = current_user.user_books.new(user_book_params)
    @user_book.issue_date = Time.now

    respond_to do |format|
      if @user_book.save
        format.html { redirect_to @user_book, notice: 'User Book history was successfully created.' }
        format.json { render :show, status: :created, location: @user_book }
      else
        format.html { render :new }
        format.json { render json: @user_book.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user_book.update(user_book_params)
        format.html { redirect_to @user_book, notice: 'User Book history was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_book }
      else
        format.html { render :edit }
        format.json { render json: @user_book.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user_book.destroy
    respond_to do |format|
      format.html { redirect_to user_books_url, notice: 'User Book history was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_user_book
      @user_book = UserBook.find_by(id: params[:id], user: current_user)
    end

    def user_book_params
      params.require(:user_book).permit(:book_id, :issue_date, :return_date, :user_id)
    end
end