class AuthorsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_author, only: [:show, :edit, :update, :destroy]

  def index
    if params[:query]
      @authors = Author.where('name LIKE ?', "%#{params[:query]}%")
    else
      authors = Author.all
    end

    respond_to do |format|
      format.html
      format.json { render json: authors_as_json }
    end
  end

  def show
    @general_library_books = @author.books.where(general_library: true)
    @user_library_books = current_user.books.where(author: @author)
  end

  def new
    @author = Author.new
  end

  def create
    @author = Author.new(author_params)
    if @author.save
      render json: { id: @author.id, name: @author.name }
    else
      render json: { errors: @author.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @author.update(author_params)
      redirect_to authors_path, notice: 'Author was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @author.destroy
    redirect_to authors_path, notice: 'Author was successfully destroyed.'
  end

  private

  def set_author
    @author = Author.find(params[:id])
  end

  def author_params
    params.require(:author).permit(:name, :bio)
  end

  def authors_as_json
    authors = if params[:query]
                Author.where('name LIKE ?', "%#{params[:query]}%")
              else
                Author.all
              end
    authors.map { |author| { id: author.id, name: author.name } }
  end
end
