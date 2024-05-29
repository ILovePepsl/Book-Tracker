class AddDetailsToBooks < ActiveRecord::Migration[7.1]
  def change
    add_column :books, :rating, :integer
    add_column :books, :quotes, :text
    add_column :books, :notes, :text
  end
end
