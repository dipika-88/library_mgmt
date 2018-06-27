class AddFieldsToBooks < ActiveRecord::Migration[5.1]
  def change
  	rename_column :books, :title, :name
  	rename_column :books, :description, :summary
  	add_column :books, :price, :decimal, :precision => 8, :scale => 2
  	add_column :books, :cover_image, :string

  end
end
