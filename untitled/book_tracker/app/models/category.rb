class Category < ApplicationRecord
  has_many :book_categories
  has_many :books, through: :book_categories

  def self.ransackable_attributes(auth_object = nil)
    %w[id name created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[book_categories books]
  end
end
