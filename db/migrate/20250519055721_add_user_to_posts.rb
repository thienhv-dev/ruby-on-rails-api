class AddUserToPosts < ActiveRecord::Migration[7.2]
  def change
    change_column_null :posts, :user_id, false

    add_foreign_key :posts, :users unless foreign_key_exists?(:posts, :users)
  end
end
