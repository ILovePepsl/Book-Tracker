class BookListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book_list, only: [:show, :edit, :update, :destroy, :remove_book_from_list]

  def index
    @book_lists = current_user.book_lists
  end

  def show
    @books = @book_list.books
  end

  def new
    @book_list = current_user.book_lists.build
  end

  def create
    @book_list = current_user.book_lists.build(book_list_params)
    if @book_list.save
      redirect_to book_lists_path, notice: 'Book list was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @book_list.update(book_list_params)
      redirect_to book_lists_path, notice: 'Book list was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if ['Хочу прочитать', 'Сейчас читаю', 'Прочитал'].include?(@book_list.name)
      redirect_to book_lists_path, alert: 'You cannot delete this list.'
    else
      @book_list.destroy
      redirect_to book_lists_path, notice: 'Book list was successfully destroyed.'
    end
  end

  def remove_book_from_list
    book = Book.find(params[:book_id])
    @book_list.books.delete(book)
    redirect_to book_list_path(@book_list), notice: 'Book was successfully removed from the list.'
  end

  private

  def set_book_list
    @book_list = current_user.book_lists.find(params[:id])
  end

  def book_list_params
    params.require(:book_list).permit(:name, book_ids: [])
  end
end
