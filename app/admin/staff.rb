ActiveAdmin.register Staff do
  permit_params :first_name, :last_name, :email, :password, :password_confirmation

  index do
    column :first_name
    column :last_name
    column :email
    column :created_at
    actions
  end

  form do |f|
    f.inputs 'Credentials' do
      f.input :first_name, required: true
      f.input :last_name, required: true
      f.input :email, required: true
      f.input :password, required: true
      f.input :password_confirmation, required: true
    end

    f.actions
  end
end