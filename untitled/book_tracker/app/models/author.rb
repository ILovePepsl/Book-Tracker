class Author < ApplicationRecord
  has_many :books

  def self.ransackable_attributes(auth_object = nil)
    %w[bio created_at id name updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[books]
  end
end
