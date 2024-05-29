class Note < ApplicationRecord
  belongs_to :book

  def self.ransackable_attributes(auth_object = nil)
    %w[id content book_id created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[book]
  end
end
