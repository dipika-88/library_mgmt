ActiveAdmin.register UserBook do
  permit_params :book_id, :user_id, :issue_date, :return_date
end
