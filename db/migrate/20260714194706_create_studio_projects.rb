class CreateStudioProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :studio_projects do |t|
      t.string :name, null: false
      t.string :client, null: false
      t.date :deadline, null: false
      t.string :status, null: false
      t.references :employee, null: true, foreign_key: true

      t.timestamps
    end
  end
end
