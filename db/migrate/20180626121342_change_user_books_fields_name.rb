class ChangeUserBooksFieldsName < ActiveRecord::Migration[5.1]
  def change
  	rename_column :user_books, :date_of_issue, :issue_date
  	rename_column :user_books, :date_of_return, :return_date
  	change_column :user_books, :status, :integer, default: 0

  end
end
