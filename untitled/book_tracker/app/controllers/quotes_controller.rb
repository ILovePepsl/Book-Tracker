class QuotesController < ApplicationController
  before_action :set_book

  def create
    @quote = @book.quotes.build(quote_params)
    if @quote.save
      redirect_to @book, notice: 'Quote was successfully added.'
    else
      redirect_to @book, alert: 'Failed to add quote.'
    end
  end

  def destroy
    @quote = @book.quotes.find(params[:id])
    @quote.destroy
    redirect_to @book, notice: 'Quote was successfully removed.'
  end

  private

  def set_book
    @book = current_user.books.find(params[:book_id])
  end

  def quote_params
    params.require(:quote).permit(:content)
  end
end
