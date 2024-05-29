class BookList < ApplicationRecord
  belongs_to :user
  has_many :list_books, dependent: :destroy
  has_many :books, through: :list_books

  validates :name, presence: true, uniqueness: { scope: :user_id, message: 'You already have a list with this name.' }
end
