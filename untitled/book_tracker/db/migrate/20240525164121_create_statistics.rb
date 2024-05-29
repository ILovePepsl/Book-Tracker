class CreateStatistics < ActiveRecord::Migration[7.1]
  def change
    create_table :statistics do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :total_books
      t.integer :total_pages
      t.float :average_rating
      t.text :genre_distribution
      t.text :monthly_books
      t.text :monthly_pages

      t.timestamps
    end
  end
end
