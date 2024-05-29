module AchievementsHelper
  def progress_bar(achievement, user)
    case achievement.name
    when 'Библиофил'
      total = 100
      current = [user.total_books_read, total].min
    when 'Скоростной читатель'
      total = 1
      current = [user.books.where('started_reading_on = finished_reading_on').count, total].min
    when 'Марафон чтения'
      total = 5
      current = [user.book_lists.find_by(name: 'Прочитал').books.group_by { |book| book.finished_reading_on.strftime('%Y-%m') }.map { |month, books| books.count }.max || 0, total].min
    when 'Начинающий читатель'
      total = 1
      current = [user.total_books_read, total].min
    when 'Годовой марафон'
      total = 10
      current = [user.books_read_count_this_year, total].min
    when 'Полка разнообразия'
      total = 5
      current = [user.unique_categories_count_from_books, total].min
    when 'Мастер цитат'
      total = 10
      current = [user.total_quotes_added, total].min
    when 'Что-то важное'
      total = 20
      current = [user.total_notes_written, total].min
    else
      total = 1
      current = 0
    end

    progress = (current.to_f / total * 100).round
    content_tag :div, class: 'progress' do
      content_tag(:div, "#{progress}%", class: 'progress-bar', style: "width: #{progress}%")
    end
  end
end
