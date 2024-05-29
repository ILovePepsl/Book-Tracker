class StatisticsController < ApplicationController
  before_action :authenticate_user!

  def index
    @total_books_read = current_user.total_books_read
    @genre_distribution = genre_distribution
    @books_read_by_month_and_year = books_read_by_month_and_year
    @average_rating = average_rating
    @rating_distribution = rating_distribution
    @total_notes = total_notes
    @total_quotes = total_quotes
    @average_reading_time = current_user.average_reading_time
    @books_by_authors = books_by_authors
  end

  private

  def genre_distribution
    genres = current_user.book_lists.find_by(name: 'Прочитал').books.joins(:categories).group('categories.name').count
    genres.map { |genre, count| { name: genre, y: count } }
  end

  def books_read_by_month_and_year
    books = current_user.book_lists.find_by(name: 'Прочитал').books.group_by_year(:finished_reading_on, format: "%Y").count
    monthly_books = current_user.book_lists.find_by(name: 'Прочитал').books.group_by { |book| book.finished_reading_on.strftime("%B") }.transform_values(&:count)
    { yearly: books, monthly: monthly_books }
  end

  def average_rating
    current_user.book_lists.find_by(name: 'Прочитал').books.average(:rating).to_f.round(2)
  end

  def rating_distribution
    current_user.book_lists.find_by(name: 'Прочитал').books.group(:rating).count
  end

  def total_notes
    current_user.books.joins(:notes).count
  end

  def total_quotes
    current_user.books.joins(:quotes).count
  end

  def books_by_authors
    current_user.books_by_authors.map { |author, count| { name: author, y: count } }
  end
end
