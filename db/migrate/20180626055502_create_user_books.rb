class CreateUserBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :user_books do |t|
      t.references :user, foreign_key: true
      t.references :book, foreign_key: true
      t.datetime :date_of_issue
      t.datetime :date_of_return
      t.integer :status
      t.timestamps
    end
  end
end
