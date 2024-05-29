class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    if params[:query]
      @categories = Category.where('name LIKE ?', "%#{params[:query]}%")
    else
      @categories = Category.all
    end

    respond_to do |format|
      format.html
      format.json { render json: @categories }
    end
  end

  def show
    @general_library_books = @category.books.where(general_library: true)
    @user_library_books = current_user.books.joins(:categories).where(categories: { id: @category.id })
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      render json: { id: @category.id, name: @category.name }
    else
      render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to categories_path, notice: 'Category was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_path, notice: 'Category was successfully destroyed.'
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
