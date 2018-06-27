class AddRoleToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :role, :integer
    User.create! do |u|
        u.email = 'admin@example.com'
        u.password = 'adminpassword'
        u.role = 'administrator'
     end
  end
end
