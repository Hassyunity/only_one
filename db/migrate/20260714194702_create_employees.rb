class CreateEmployees < ActiveRecord::Migration[8.0]
  def change
    create_table :employees do |t|
      t.string :name, null: false
      t.string :job_title, null: false
      t.string :department, null: false
      t.string :status, null: false

      t.timestamps
    end
  end
end
