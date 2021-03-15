class Admin::BooksController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :admin_user
  before_action :find_book, only: [:show, :edit, :update, :destroy]
  before_action{flash.clear}

  def index
    @books = Book.all
  end

  def show

  end

  def new
    @book = Book.new
  end

  def edit

  end

  def create
    @category = Category.find_by id: params[:category_id]
    Category.transaction do
      unless @category.present?
        category = Category.create!(name: params[:book][:category_id])
        params[:book][:category_id] = category.id
      end
      @book = Book.new book_params
      @book.image.attach(params[:book][:image])
      if @book.save
        flash[:success]="Book created!"
        redirect_to admin_book_path(@book)
      else
        flash[:danger]="Creating book fail!"
        redirect_to new_admin_book_path
        raise ActiveRecord::Rollback
      end
    end
  end

  def update
    if @book.update book_params
      flash[:success] = "Book updated"
      redirect_to admin_book_path(@book)
    else
      flash[:danger] = "Update failed"
      render :edit
    end
  end


  def destroy
    @book.destroy
    flash[:success] = "Book deleted"
    redirect_to
  end

  private
    def find_book
      @book =  Book.find_by id: params[:id]
      unless @book.present?
        flash[:danger] = "Book doesn't exist"
        redirect_to admin_books_path
      end
    end

    def book_params
      params.require(:book).permit :name, :author_id, :category_id, :description, :image
    end

    def admin_user
      redirect_to root_url unless current_user.role_admin?
    end
end
