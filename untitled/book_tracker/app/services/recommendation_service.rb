class RecommendationService
  MIN_BOOKS_READ = 10
  MAX_RECOMMENDED_BOOKS = 20

  def initialize(user)
    @user = user
  end

  def recommended_books_with_reasons
    return [] if @user.total_books_read < MIN_BOOKS_READ

    popular_categories = popular_categories_from_books_read
    popular_authors = popular_authors_from_books_read

    recommended_books = interleave_books_by_categories_and_authors(popular_categories, popular_authors)
    recommended_books.uniq! { |book_with_reason| book_with_reason[:book].id }
    recommended_books.reject! { |book_with_reason| book_already_in_user_library?(book_with_reason[:book]) }
    recommended_books.first(MAX_RECOMMENDED_BOOKS)
  end

  private

  def popular_categories_from_books_read
    @user.book_lists.find_by(name: 'Прочитал').books.joins(:categories).group('categories.name').order('count_all DESC').limit(3).count.keys
  end

  def popular_authors_from_books_read
    @user.book_lists.find_by(name: 'Прочитал').books.joins(:author).group('authors.name').order('count_all DESC').limit(2).count.keys
  end

  def interleave_books_by_categories_and_authors(categories, authors)
    books_by_categories = categories.flat_map do |category|
      Book.general_library
          .joins(:categories)
          .where(categories: { name: category })
          .where.not(id: @user.books.pluck(:id))
          .where.not(title: @user.book_lists.find_by(name: 'Прочитал').books.pluck(:title))
          .distinct
          .map { |book| { book: book, reason: "Вы любите категорию #{category}" } }
    end

    books_by_authors = authors.flat_map do |author|
      Book.general_library
          .joins(:author)
          .where(authors: { name: author })
          .where.not(id: @user.books.pluck(:id))
          .where.not(title: @user.book_lists.find_by(name: 'Прочитал').books.pluck(:title))
          .distinct
          .map { |book| { book: book, reason: "Вы любите творчество #{author}" } }
    end

    interleaved_books = []
    max_length = [books_by_categories.length, books_by_authors.length].max
    max_length.times do |i|
      interleaved_books << books_by_categories[i] if i < books_by_categories.length
      interleaved_books << books_by_authors[i] if i < books_by_authors.length
    end

    interleaved_books
  end

  def book_already_in_user_library?(book)
    @user.books.exists?(title: book.title)
  end
end
