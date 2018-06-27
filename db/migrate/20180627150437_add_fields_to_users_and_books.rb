class AddFieldsToUsersAndBooks < ActiveRecord::Migration[5.1]
  def change
  	add_column :users, :name, :string
  	add_column :books, :author, :string
  end
end
