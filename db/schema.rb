# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_07_14_194709) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "conge_requests", force: :cascade do |t|
    t.integer "employee_id", null: false
    t.string "leave_type", null: false
    t.date "starts_on", null: false
    t.date "ends_on", null: false
    t.string "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_conge_requests_on_employee_id"
  end

  create_table "dev_tickets", force: :cascade do |t|
    t.string "title", null: false
    t.string "priority", null: false
    t.string "sprint", null: false
    t.string "status", null: false
    t.integer "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_dev_tickets_on_employee_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "name", null: false
    t.string "job_title", null: false
    t.string "department", null: false
    t.string "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leads", force: :cascade do |t|
    t.string "name", null: false
    t.string "company", null: false
    t.integer "value", default: 0, null: false
    t.string "stage", null: false
    t.string "owner_type", null: false
    t.integer "employee_id"
    t.json "tags"
    t.integer "tasks_done"
    t.integer "tasks_total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_leads_on_employee_id"
  end

  create_table "studio_projects", force: :cascade do |t|
    t.string "name", null: false
    t.string "client", null: false
    t.date "deadline", null: false
    t.string "status", null: false
    t.integer "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_studio_projects_on_employee_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "name", null: false
    t.string "role", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "conge_requests", "employees"
  add_foreign_key "dev_tickets", "employees"
  add_foreign_key "leads", "employees"
  add_foreign_key "studio_projects", "employees"
end
