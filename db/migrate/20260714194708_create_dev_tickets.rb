class CreateDevTickets < ActiveRecord::Migration[8.0]
  def change
    create_table :dev_tickets do |t|
      t.string :title, null: false
      t.string :priority, null: false
      t.string :sprint, null: false
      t.string :status, null: false
      t.references :employee, null: true, foreign_key: true

      t.timestamps
    end
  end
end
