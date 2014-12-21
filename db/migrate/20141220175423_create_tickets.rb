class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :customer_name
      t.string :customer_email
      t.text :question
      t.text :answer
      t.string :status
      t.references :staff
      t.timestamps
    end
  end
end