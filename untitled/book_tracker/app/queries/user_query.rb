class UserQuery
  def self.books_read_this_year(user)
    book_list = user.book_lists.find_by(name: 'Прочитал')
    book_list.books.where('finished_reading_on >= ? AND finished_reading_on <= ?', Time.current.beginning_of_year, Time.current.end_of_year)
  end

  def self.total_books_read(user)
    book_list = user.book_lists.find_by(name: 'Прочитал')
    book_list.books.count
  end

  def self.total_quotes_added(user)
    user.books.joins(:quotes).count
  end

  def self.total_notes_written(user)
    user.books.joins(:notes).count
  end

  def self.average_reading_time(user)
    books = user.book_lists.find_by(name: 'Прочитал').books
    return 0 if books.empty?

    total_days = books.sum { |book| (book.finished_reading_on - book.started_reading_on).to_i }
    (total_days / books.size).round
  end

  def self.books_by_authors(user)
    user.book_lists.find_by(name: 'Прочитал').books.joins(:author).group('authors.name').count
  end

  def self.unique_categories_count_from_books(user)
    unique_categories = Set.new
    user.book_lists.find_by(name: 'Прочитал').books.each do |book|
      book.categories.each do |category|
        unique_categories.add(category.name) unless unique_categories.include?(category.name)
      end
      break if unique_categories.size >= 5
    end
    unique_categories.size
  end
end
