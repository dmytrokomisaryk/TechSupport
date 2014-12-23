class CreateTicketAnswers < ActiveRecord::Migration
  def change
    create_table :ticket_answers do |t|
      t.references :ticket
      t.text :text
      t.string :author

      t.timestamps
    end
  end
end
