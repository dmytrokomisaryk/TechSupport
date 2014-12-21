ActiveAdmin.register Ticket do
  permit_params :customer_name, :customer_email, :message, :staff_id

  form do |f|
    f.inputs 'Customer details' do
      f.input :customer_name
      f.input :customer_email
    end

    f.inputs 'Issue' do
      f.input :message
    end

    f.inputs 'Assign' do
      staff = Staff.all.map{ |staff| [staff.full_name, staff.id] }
      f.input :staff_id,
              label: 'Staff',
              as: :select,
              collection: staff
    end

    f.actions
  end
end
