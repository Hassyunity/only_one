class CreateCongeRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :conge_requests do |t|
      t.references :employee, null: false, foreign_key: true
      t.string :leave_type, null: false
      t.date :starts_on, null: false
      t.date :ends_on, null: false
      t.string :status, null: false

      t.timestamps
    end
  end
end
