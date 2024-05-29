class CreateListBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :list_books do |t|
      t.references :book_list, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true
      t.integer :progress
      t.float :rating
      t.text :notes
      t.text :quotes

      t.timestamps
    end
  end
end
