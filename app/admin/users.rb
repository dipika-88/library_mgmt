ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :role, :name
  filter :email
  index do
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    column :role
    actions
  end

  form do |f|
    f.inputs 'User Details' do
      f.input :name
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :role, as: :radio, collection: { User: 'user', Admin: 'admin', Administrator: 'administrator' }
    end
    f.actions
  end
end
