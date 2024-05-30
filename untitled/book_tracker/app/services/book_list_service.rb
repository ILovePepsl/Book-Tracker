class BookListService
  def initialize(user, book)
    @user = user
    @book = book
  end

  def add_to_list(list_name)
    list = @user.book_lists.find_by(name: list_name)
    return if list.nil?

    list.books << @book unless list.books.include?(@book)
  end

  def remove_from_list(list_name)
    list = @user.book_lists.find_by(name: list_name)
    return if list.nil?

    list.books.delete(@book)
  end
end
