class AddUsernameToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :username, :string
  end
end
