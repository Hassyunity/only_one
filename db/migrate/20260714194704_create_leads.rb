class CreateLeads < ActiveRecord::Migration[8.0]
  def change
    create_table :leads do |t|
      t.string :name, null: false
      t.string :company, null: false
      t.integer :value, null: false, default: 0
      t.string :stage, null: false
      t.string :owner_type, null: false
      t.references :employee, null: true, foreign_key: true
      t.json :tags
      t.integer :tasks_done
      t.integer :tasks_total

      t.timestamps
    end
  end
end
