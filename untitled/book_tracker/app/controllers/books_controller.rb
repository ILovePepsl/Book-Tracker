class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: [:show, :edit, :update, :destroy, :set_status, :add_to_list]
  before_action :set_authors_and_categories, only: [:new, :edit, :create, :update]

  def index
    @books = current_user.books
  end

  def show
    @user_lists = current_user.book_lists.where.not(name: ['Хочу прочитать', 'Сейчас читаю', 'Прочитал'])
  end

  def new
    @book = current_user.books.build
  end

  def create
    @book = current_user.books.build(book_params)
    if @book.save
      current_user.check_achievements
      redirect_to books_path, notice: 'Book was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      current_user.check_achievements
      redirect_to books_path, notice: 'Book was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path, notice: 'Book was successfully destroyed.'
  end

  def set_status
    case params[:status]
    when 'Прочитал'
      @book.update(status: params[:status], started_reading_on: params[:started_reading_on], finished_reading_on: params[:finished_reading_on], rating: params[:rating])
      @book.add_to_list('Прочитал')
      @book.remove_from_list('Хочу прочитать')
      @book.remove_from_list('Сейчас читаю')
    when 'Хочу прочитать'
      @book.update(status: params[:status])
      @book.add_to_list('Хочу прочитать')
      @book.remove_from_list('Прочитал')
      @book.remove_from_list('Сейчас читаю')
    when 'Сейчас читаю'
      @book.update(status: params[:status])
      @book.add_to_list('Сейчас читаю')
      @book.remove_from_list('Прочитал')
      @book.remove_from_list('Хочу прочитать')
    end
    current_user.check_achievements
    redirect_to book_path(@book), notice: 'Status and list were successfully updated.'
  end

  def add_to_list
    list = current_user.book_lists.find_by(name: params[:list_name])
    list.books << @book unless list.books.include?(@book)
    current_user.check_achievements
    redirect_to book_path(@book), notice: 'Book was successfully added to the list.'
  end

  private

  def set_book
    @book = Book.find_by(id: params[:id], user: [current_user, nil])
  end

  def set_authors_and_categories
    @authors = Author.all
    @categories = Category.all
  end

  def book_params
    params.require(:book).permit(:title, :description, :cover_image, :author_id, :status, :started_reading_on, :finished_reading_on, :rating, :quotes, :notes, category_ids: [])
  end
end
