class AddReadingDatesToBooks < ActiveRecord::Migration[7.1]
  def change
    add_column :books, :started_reading_on, :date
    add_column :books, :finished_reading_on, :date
  end
end
