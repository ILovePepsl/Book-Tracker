class NotesController < ApplicationController
  before_action :set_book

  def create
    @note = @book.notes.build(note_params)
    if @note.save
      redirect_to @book, notice: 'Note was successfully added.'
    else
      redirect_to @book, alert: 'Failed to add note.'
    end
  end

  def destroy
    @note = @book.notes.find(params[:id])
    @note.destroy
    redirect_to @book, notice: 'Note was successfully removed.'
  end

  private

  def set_book
    @book = current_user.books.find(params[:book_id])
  end

  def note_params
    params.require(:note).permit(:content)
  end
end
