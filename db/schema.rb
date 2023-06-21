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

ActiveRecord::Schema[7.0].define(version: 2023_06_21_122620) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "internal_name"
  end

  create_table "comments", force: :cascade do |t|
    t.string "name"
    t.text "comment"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "post_id"
    t.index ["post_id"], name: "index_comments_on_post_id"
  end

  create_table "coupons", force: :cascade do |t|
    t.string "name"
    t.integer "value"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "impressions", force: :cascade do |t|
    t.string "impressionable_type"
    t.integer "impressionable_id"
    t.integer "user_id"
    t.string "controller_name"
    t.string "action_name"
    t.string "view_name"
    t.string "request_hash"
    t.string "ip_address"
    t.string "session_hash"
    t.text "message"
    t.text "referrer"
    t.text "params"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index"
    t.index ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index"
    t.index ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index"
    t.index ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index"
    t.index ["impressionable_type", "impressionable_id", "params"], name: "poly_params_request_index"
    t.index ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index"
    t.index ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index"
    t.index ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index"
    t.index ["user_id"], name: "index_impressions_on_user_id"
  end

  create_table "inscriptions", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "job_id"
    t.bigint "user_id"
    t.integer "status"
    t.boolean "recommended", default: false
    t.boolean "added_by_company", default: false
    t.index ["job_id"], name: "index_inscriptions_on_job_id"
    t.index ["user_id"], name: "index_inscriptions_on_user_id"
  end

  create_table "job_prices", force: :cascade do |t|
    t.string "name"
    t.string "internal_name"
    t.integer "value"
    t.integer "value_with_taxes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "job_skills", id: :serial, force: :cascade do |t|
    t.integer "job_id"
    t.integer "skill_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["job_id"], name: "index_job_skills_on_job_id"
    t.index ["skill_id"], name: "index_job_skills_on_skill_id"
  end

  create_table "job_types", force: :cascade do |t|
    t.string "name"
    t.string "internal_name"
  end

  create_table "jobs", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "url"
    t.string "location"
    t.string "job_author"
    t.boolean "remote_ok"
    t.string "apply_url"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "avatar"
    t.integer "salary_from"
    t.integer "salary_to"
    t.boolean "open", default: true
    t.bigint "category_id"
    t.float "latitude"
    t.float "longitude"
    t.bigint "job_type_id"
    t.datetime "expiry_date", precision: nil
    t.bigint "user_id"
    t.bigint "level_id"
    t.string "reference"
    t.string "slug"
    t.string "external_mail", default: "", null: false
    t.string "discount_code"
    t.bigint "partner_id"
    t.bigint "job_price_id"
    t.index ["category_id"], name: "index_jobs_on_category_id"
    t.index ["job_price_id"], name: "index_jobs_on_job_price_id"
    t.index ["job_type_id"], name: "index_jobs_on_job_type_id"
    t.index ["level_id"], name: "index_jobs_on_level_id"
    t.index ["partner_id"], name: "index_jobs_on_partner_id"
    t.index ["slug"], name: "index_jobs_on_slug", unique: true
    t.index ["user_id"], name: "index_jobs_on_user_id"
  end

  create_table "levels", force: :cascade do |t|
    t.string "name"
    t.string "internal_name"
  end

  create_table "partners", force: :cascade do |t|
    t.string "name"
    t.string "token"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "image"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "meta_title"
    t.string "meta_description"
    t.string "custom_url"
    t.string "slug"
    t.index ["slug"], name: "index_posts_on_slug", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "skills", id: :serial, force: :cascade do |t|
    t.string "internal_name"
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "job_id"
    t.bigint "tag_id"
    t.index ["job_id"], name: "index_taggings_on_job_id"
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
  end

  create_table "user_skills", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "skill_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["skill_id"], name: "index_user_skills_on_skill_id"
    t.index ["user_id"], name: "index_user_skills_on_user_id"
  end

  create_table "user_types", force: :cascade do |t|
    t.string "name"
    t.string "internal_name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "name"
    t.string "last_name"
    t.string "picture_url"
    t.string "profile_url"
    t.string "location"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "stripe_id"
    t.string "card_brand"
    t.string "card_last4"
    t.string "card_exp_month"
    t.string "card_exp_year"
    t.datetime "expires_at", precision: nil
    t.boolean "admin"
    t.string "provider"
    t.string "uid"
    t.bigint "user_type_id"
    t.string "current_position"
    t.boolean "accepted_terms", default: false
    t.string "phone"
    t.text "description"
    t.string "personal_website"
    t.string "github"
    t.string "pinterest"
    t.string "behance"
    t.integer "salary_from"
    t.integer "salary_to"
    t.boolean "visible", default: true
    t.string "experience"
    t.string "resident_state"
    t.string "resident_country"
    t.string "resident_country_code"
    t.string "resident_city"
    t.string "resident_postal_code"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.boolean "ambassador", default: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["user_type_id"], name: "index_users_on_user_type_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comments", "posts"
  add_foreign_key "inscriptions", "jobs"
  add_foreign_key "inscriptions", "users"
  add_foreign_key "jobs", "categories"
  add_foreign_key "jobs", "job_prices"
  add_foreign_key "jobs", "job_types"
  add_foreign_key "jobs", "levels"
  add_foreign_key "jobs", "partners"
  add_foreign_key "jobs", "users"
  add_foreign_key "taggings", "jobs"
  add_foreign_key "taggings", "tags"
  add_foreign_key "users", "user_types"
end
