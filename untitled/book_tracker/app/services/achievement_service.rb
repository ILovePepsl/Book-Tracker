class AchievementService
  def initialize(user)
    @user = user
  end

  def check_achievements
    check_bibliophile
    check_speed_reader
    check_marathon_reader
    check_beginner_reader
    check_annual_marathon
    check_diversity_shelf
    check_quote_master
    check_important_note
  end

  private

  def check_bibliophile
    achievement = @user.achievements.find_by(name: 'Библиофил')
    achievement.update(completed: @user.total_books_read >= 100)
  end

  def check_speed_reader
    achievement = @user.achievements.find_by(name: 'Скоростной читатель')
    achievement.update(completed: @user.books.where('started_reading_on = finished_reading_on').exists?)
  end

  def check_marathon_reader
    achievement = @user.achievements.find_by(name: 'Марафон чтения')
    completed = @user.book_lists.find_by(name: 'Прочитал').books.group_by { |book| book.finished_reading_on.strftime('%Y-%m') }.any? { |month, books| books.count >= 5 }
    achievement.update(completed: completed)
  end

  def check_beginner_reader
    achievement = @user.achievements.find_by(name: 'Начинающий читатель')
    achievement.update(completed: @user.total_books_read >= 1)
  end

  def check_annual_marathon
    achievement = @user.achievements.find_by(name: 'Годовой марафон')
    achievement.update(completed: @user.books_read_count_this_year >= 10)
  end

  def check_diversity_shelf
    achievement = @user.achievements.find_by(name: 'Полка разнообразия')
    achievement.update(completed: @user.unique_categories_count_from_books >= 5)
  end

  def check_quote_master
    achievement = @user.achievements.find_by(name: 'Мастер цитат')
    achievement.update(completed: @user.total_quotes_added >= 10)
  end

  def check_important_note
    achievement = @user.achievements.find_by(name: 'Что-то важное')
    achievement.update(completed: @user.total_notes_written >= 20)
  end
end
