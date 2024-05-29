class ReadingCalendarsController < ApplicationController
  before_action :authenticate_user!

  def index
    @year = params[:year].presence || Time.current.year
    @month = params[:month].presence

    @books = current_user.book_lists.find_by(name: 'Прочитал').books
    if @month.present?
      start_date = Date.new(@year.to_i, @month.to_i, 1)
      end_date = start_date.end_of_month
    else
      start_date = Date.new(@year.to_i, 1, 1)
      end_date = start_date.end_of_year
    end
    @books = @books.where('started_reading_on <= ? AND finished_reading_on >= ?', end_date, start_date)
  end
end
