class ListBook < ApplicationRecord
  belongs_to :book_list
  belongs_to :book

  def self.ransackable_attributes(auth_object = nil)
    %w[id book_list_id book_id created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[book_list book]
  end
end
