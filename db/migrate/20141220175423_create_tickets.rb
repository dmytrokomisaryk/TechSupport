class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :customer_name
      t.string :customer_email
      t.text :message
      t.string :status
      t.references :staff
      t.timestamps
    end
  end
end
