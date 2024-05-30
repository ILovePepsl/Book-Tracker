class BookQuery
  def self.general_library(query = nil, page = nil, per_page = 15)
    scope = Book.where(user: nil)
    scope = scope.where('title LIKE ? OR description LIKE ?', "%#{query}%", "%#{query}%") if query.present?
    scope.page(page).per(per_page)
  end
end
