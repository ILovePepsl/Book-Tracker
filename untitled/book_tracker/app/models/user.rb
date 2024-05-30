class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :books
  has_many :book_lists, dependent: :destroy
  has_many :achievements
  has_many :reading_calendars
  has_many :statistics

  has_one_attached :avatar

  validates :username, presence: true

  after_create :create_default_book_lists, :create_achievements
  before_validation :assign_random_username_and_avatar, on: :create

  USERNAMES_AND_AVATARS = {
    'Alice' => 'alice.jpg',
    'Frankenstein' => 'frankenstein.jpg',
    'Lovecraft' => 'lovecraft.jpg',
    'It' => 'it.jpg',
    'Edgar Allan Poe' => 'poe.jpg',
    'Shakespeare' => 'shakespeare.png',
    'Kafka' => 'kafka.jpg',
    'Black cat' => 'cat.jpg'
  }

  def create_default_book_lists
    book_lists.create(name: 'Хочу прочитать')
    book_lists.create(name: 'Сейчас читаю')
    book_lists.create(name: 'Прочитал')
  end

  def create_achievements
    achievements.create(name: 'Библиофил', description: 'Прочитать 100 книг.', completed: false)
    achievements.create(name: 'Скоростной читатель', description: 'Прочитать книгу за один день.', completed: false)
    achievements.create(name: 'Марафон чтения', description: 'Прочитать 5 книг за месяц.', completed: false)
    achievements.create(name: 'Начинающий читатель', description: 'Прочитать первую книгу.', completed: false)
    achievements.create(name: 'Годовой марафон', description: 'Прочитать 10 книг за год.', completed: false)
    achievements.create(name: 'Полка разнообразия', description: 'Прочитать книги из пяти разных категорий.', completed: false)
    achievements.create(name: 'Мастер цитат', description: 'Добавить 10 цитат.', completed: false)
    achievements.create(name: 'Что-то важное', description: 'Написать 20 заметок.', completed: false)
  end

  def books_read_this_year
    book_list = book_lists.find_by(name: 'Прочитал')
    book_list.books.where('finished_reading_on >= ? AND finished_reading_on <= ?', Time.current.beginning_of_year, Time.current.end_of_year)
  end

  def books_read_count_this_year
    books_read_this_year.count
  end

  def goal_progress
    return 0 if reading_goal.nil? || reading_goal.zero?

    (books_read_count_this_year.to_f / reading_goal * 100).round
  end

  def total_books_read
    book_list = book_lists.find_by(name: 'Прочитал')
    book_list.books.count
  end

  def total_quotes_added
    books.joins(:quotes).count
  end

  def total_notes_written
    books.joins(:notes).count
  end

  def average_reading_time
    books = book_lists.find_by(name: 'Прочитал').books
    return 0 if books.empty?

    total_days = books.sum { |book| (book.finished_reading_on - book.started_reading_on).to_i }
    (total_days / books.size).round
  end

  def books_by_authors
    book_lists.find_by(name: 'Прочитал').books.joins(:author).group('authors.name').count
  end

  def unique_categories_count_from_books
    unique_categories = Set.new
    book_lists.find_by(name: 'Прочитал').books.each do |book|
      book.categories.each do |category|
        unique_categories.add(category.name) unless unique_categories.include?(category.name)
      end
      break if unique_categories.size >= 5
    end
    unique_categories.size
  end

  def all_book_ids
    books.pluck(:id)
  end

  def check_achievements
    AchievementService.new(self).check_achievements
  end

  def achievements_percentage
    total_achievements = achievements.count
    return 0 if total_achievements.zero?

    completed_achievements = achievements.where(completed: true).count
    ((completed_achievements.to_f / total_achievements) * 100).round
  end

  def sorted_achievements
    achievements.order(completed: :desc)
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[achievements_percentage avatar created_at email id reading_goal remember_created_at reset_password_sent_at total_books total_pages updated_at username]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[books book_lists achievements reading_calendars statistics]
  end

  private

  def assign_random_username_and_avatar
    username, avatar_filename = USERNAMES_AND_AVATARS.to_a.sample
    self.username = username
    avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', avatar_filename)), filename: avatar_filename, content_type: 'image/jpg')
  end
end
