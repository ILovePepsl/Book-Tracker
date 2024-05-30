class RecommendationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @recommended_books_with_reasons = RecommendationService.new(current_user).recommended_books_with_reasons
  end
end
