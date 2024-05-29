class ChangeUserIdInBooks < ActiveRecord::Migration[7.1]
  def change
    change_column_null :books, :user_id, true
  end
end
