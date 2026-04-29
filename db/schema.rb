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

ActiveRecord::Schema[7.1].define(version: 2026_04_29_140500) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

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

  create_table "addresses", force: :cascade do |t|
    t.string "title"
    t.bigint "profil_id", null: false
    t.string "street"
    t.string "zip_code"
    t.string "city"
    t.string "country"
    t.string "email"
    t.string "phone_number"
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profil_id"], name: "index_addresses_on_profil_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "cv_categories", force: :cascade do |t|
    t.bigint "profil_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category_title"
    t.text "content"
    t.index ["profil_id"], name: "index_cv_categories_on_profil_id"
  end

  create_table "inner_portraits", force: :cascade do |t|
    t.string "slug"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password"
    t.text "text"
    t.index ["slug"], name: "index_inner_portraits_on_slug"
  end

  create_table "photos", force: :cascade do |t|
    t.string "url"
    t.bigint "work_id", null: false
    t.string "legend"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "cover", default: false
    t.index ["work_id"], name: "index_photos_on_work_id"
  end

  create_table "profil", force: :cascade do |t|
    t.text "about"
    t.string "pic_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prompt_submissions", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.text "prompt_text", null: false
    t.text "answer_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "speaking_logos", force: :cascade do |t|
    t.bigint "speaking_id", null: false
    t.string "name", null: false
    t.string "destination_url"
    t.string "alt_text", null: false
    t.string "link_label"
    t.integer "position", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_url"
    t.index ["speaking_id", "position"], name: "index_speaking_logos_on_speaking_id_and_position"
    t.index ["speaking_id"], name: "index_speaking_logos_on_speaking_id"
  end

  create_table "speakings", force: :cascade do |t|
    t.text "text"
    t.string "pic_url"
    t.string "slug", default: "speaking"
    t.string "seo_title"
    t.text "seo_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "videos", force: :cascade do |t|
    t.string "url"
    t.bigint "work_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "cover", default: false
    t.bigint "speaking_id"
    t.index ["speaking_id"], name: "index_videos_on_speaking_id"
    t.index ["work_id"], name: "index_videos_on_work_id"
  end

  create_table "works", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["slug"], name: "index_works_on_slug", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addresses", "profil"
  add_foreign_key "cv_categories", "profil"
  add_foreign_key "photos", "works"
  add_foreign_key "speaking_logos", "speakings"
  add_foreign_key "videos", "speakings"
  add_foreign_key "videos", "works"
end
