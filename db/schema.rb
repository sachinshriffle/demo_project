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

ActiveRecord::Schema[7.0].define(version: 2023_09_06_113543) do
  create_table "companies", force: :cascade do |t|
    t.string "company_name"
    t.string "address"
    t.string "contact"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_companies_on_user_id"
  end

  create_table "job_applications", force: :cascade do |t|
    t.integer "user_id"
    t.integer "job_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_job_applications_on_job_id"
    t.index ["user_id"], name: "index_job_applications_on_user_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.string "job_title"
    t.string "required_skills"
    t.integer "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_jobs_on_company_id"
  end

  create_table "skills", force: :cascade do |t|
    t.string "skills"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "skills_users", id: false, force: :cascade do |t|
    t.integer "skill_id", null: false
    t.integer "user_id", null: false
    t.integer "users_id"
    t.integer "skills_id"
    t.index ["skills_id"], name: "index_skills_users_on_skills_id"
    t.index ["users_id"], name: "index_skills_users_on_users_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.integer "mobile_number"
    t.string "type"
    t.string "email"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "companies", "users"
  add_foreign_key "jobs", "companies"
end
