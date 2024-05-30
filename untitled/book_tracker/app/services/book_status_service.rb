class BookStatusService
  def initialize(book, user)
    @book = book
    @user = user
  end

  def set_status(params)
    case params[:status]
    when 'Прочитал'
      update_book(params)
      book_list_service.add_to_list('Прочитал')
      book_list_service.remove_from_list('Хочу прочитать')
      book_list_service.remove_from_list('Сейчас читаю')
    when 'Хочу прочитать'
      @book.update(status: params[:status])
      book_list_service.add_to_list('Хочу прочитать')
      book_list_service.remove_from_list('Прочитал')
      book_list_service.remove_from_list('Сейчас читаю')
    when 'Сейчас читаю'
      @book.update(status: params[:status])
      book_list_service.add_to_list('Сейчас читаю')
      book_list_service.remove_from_list('Прочитал')
      book_list_service.remove_from_list('Хочу прочитать')
    end
    @user.check_achievements
  end

  private

  def book_list_service
    @book_list_service ||= BookListService.new(@user, @book)
  end

  def update_book(params)
    @book.update(
      status: params[:status],
      started_reading_on: params[:started_reading_on],
      finished_reading_on: params[:finished_reading_on],
      rating: params[:rating]
    )
  end
end
