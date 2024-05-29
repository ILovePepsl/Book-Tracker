class AddGeneralLibraryToBooks < ActiveRecord::Migration[7.1]
  def change
    add_column :books, :general_library, :boolean, default: false
  end
end