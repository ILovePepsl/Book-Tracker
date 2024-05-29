class Book < ApplicationRecord
  belongs_to :author
  belongs_to :user, optional: true
  has_many :book_categories, dependent: :destroy
  has_many :categories, through: :book_categories
  has_many :list_books, dependent: :destroy
  has_many :book_lists, through: :list_books
  has_many :quotes, dependent: :destroy
  has_many :notes, dependent: :destroy

  has_one_attached :cover_image

  validates :title, presence: true
  validates :rating, numericality: { only_integer: true, allow_nil: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }

  # Scope for books in the general library
  scope :general_library, -> { where(user: nil) }

  def add_to_list(list_name)
    list = user.book_lists.find_by(name: list_name)
    return if list.nil?

    list.books << self unless list.books.include?(self)
  end

  def remove_from_list(list_name)
    list = user.book_lists.find_by(name: list_name)
    return if list.nil?

    list.books.delete(self)
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[title description status started_reading_on finished_reading_on rating]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[author book_categories book_lists categories cover_image_attachment cover_image_blob list_books notes quotes user]
  end
end
