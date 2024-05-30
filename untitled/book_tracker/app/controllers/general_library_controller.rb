class GeneralLibraryController < ApplicationController
  before_action :redirect_to_user_library_if_book_exists, only: [:show]

  def index
    @per_page = params[:per_page] || 15
    @query = params[:query]
    @books = BookQuery.general_library(@query, params[:page], @per_page)
  end

  def show
    @book = Book.find(params[:id])
  end

  def add_to_my_library
    original_book = Book.find(params[:id])

    if current_user.books.exists?(title: original_book.title)
      redirect_to general_library_path(original_book), alert: 'У вас уже есть книга с таким названием в библиотеке.'
      return
    end

    new_book = current_user.books.build(
      title: original_book.title,
      description: original_book.description,
      author: original_book.author
    )

    new_book.categories = original_book.categories

    if original_book.cover_image.attached?
      new_book.cover_image.attach(original_book.cover_image.blob)
    end

    if new_book.save
      redirect_to book_path(new_book), notice: 'Книга была успешно добавлена в вашу библиотеку.'
    else
      redirect_to general_library_path(original_book), alert: 'Не удалось добавить книгу в вашу библиотеку.'
    end
  end

  private

  def redirect_to_user_library_if_book_exists
    book_in_library = current_user.books.find_by(title: Book.find(params[:id]).title)
    if book_in_library
      redirect_to book_path(book_in_library)
    end
  end
end
