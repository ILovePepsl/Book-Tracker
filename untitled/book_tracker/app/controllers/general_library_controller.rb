class GeneralLibraryController < ApplicationController
  def index
    @per_page = params[:per_page] || 15
    @books = Book.where(general_library: true).page(params[:page]).per(@per_page)
  end

  def show
    @book = Book.find(params[:id])
  end

  def add_to_my_library
    original_book = Book.find(params[:id])
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
      redirect_to book_path(new_book), notice: 'Book was successfully added to your library.'
    else
      redirect_to general_library_path(original_book), alert: 'Failed to add book to your library.'
    end
  end
end
