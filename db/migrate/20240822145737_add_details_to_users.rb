class AddDetailsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :name, :string
    add_column :users, :gender, :string
    add_column :users, :birthdate, :date
    add_column :users, :bio, :text
  end
end
