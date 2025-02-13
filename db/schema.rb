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

ActiveRecord::Schema[8.0].define(version: 2025_02_12_141707) do
  create_table "account_jwt_refresh_keys", force: :cascade do |t|
    t.integer "account_id", null: false
    t.string "key", null: false
    t.datetime "deadline", null: false
    t.index ["account_id"], name: "index_account_jwt_refresh_keys_on_account_id"
  end

  create_table "account_lockouts", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "deadline", null: false
    t.datetime "email_last_sent"
  end

  create_table "account_login_change_keys", force: :cascade do |t|
    t.string "key", null: false
    t.string "login", null: false
    t.datetime "deadline", null: false
  end

  create_table "account_login_failures", force: :cascade do |t|
    t.integer "number", default: 1, null: false
  end

  create_table "account_password_reset_keys", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "deadline", null: false
    t.datetime "email_last_sent", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "account_verification_keys", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "requested_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "email_last_sent", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "accounts", force: :cascade do |t|
    t.integer "status", default: 1, null: false
    t.string "email", null: false
    t.string "password_hash"
    t.index ["email"], name: "index_accounts_on_email", unique: true, where: "status IN (1, 2)"
  end

  create_table "blob_aggregates", id: { type: :string, limit: 36 }, force: :cascade do |t|
    t.string "key", null: false
    t.integer "byte_size", limit: 8, null: false
    t.string "checksum", null: false
    t.string "storage_type", null: false
    t.string "created_by_id", limit: 36
    t.string "updated_by_id", limit: 36
    t.string "deleted_by_id", limit: 36
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_blob_aggregates_on_deleted_at"
    t.index ["key"], name: "index_blob_aggregates_on_key", unique: true
    t.index ["storage_type"], name: "index_blob_aggregates_on_storage_type"
  end

  create_table "db_storages", id: { type: :string, limit: 36 }, force: :cascade do |t|
    t.string "blob_id", limit: 36, null: false
    t.string "created_by_id", limit: 36
    t.string "updated_by_id", limit: 36
    t.string "deleted_by_id", limit: 36
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary "data", null: false
    t.index ["blob_id"], name: "index_db_storages_on_blob_id", unique: true
    t.index ["deleted_at"], name: "index_db_storages_on_deleted_at"
  end

  create_table "ftp_storages", id: { type: :string, limit: 36 }, force: :cascade do |t|
    t.string "blob_id", limit: 36, null: false
    t.string "created_by_id", limit: 36
    t.string "updated_by_id", limit: 36
    t.string "deleted_by_id", limit: 36
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "path", null: false
    t.string "host", null: false
    t.index ["blob_id"], name: "index_ftp_storages_on_blob_id", unique: true
    t.index ["deleted_at"], name: "index_ftp_storages_on_deleted_at"
  end

  create_table "local_storages", id: { type: :string, limit: 36 }, force: :cascade do |t|
    t.string "blob_id", limit: 36, null: false
    t.string "created_by_id", limit: 36
    t.string "updated_by_id", limit: 36
    t.string "deleted_by_id", limit: 36
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "full_path", null: false
    t.index ["blob_id"], name: "index_local_storages_on_blob_id", unique: true
    t.index ["deleted_at"], name: "index_local_storages_on_deleted_at"
  end

  create_table "s3_storages", id: { type: :string, limit: 36 }, force: :cascade do |t|
    t.string "blob_id", limit: 36, null: false
    t.string "created_by_id", limit: 36
    t.string "updated_by_id", limit: 36
    t.string "deleted_by_id", limit: 36
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "bucket", null: false
    t.string "key", null: false
    t.index ["blob_id"], name: "index_s3_storages_on_blob_id", unique: true
    t.index ["deleted_at"], name: "index_s3_storages_on_deleted_at"
  end

  add_foreign_key "account_jwt_refresh_keys", "accounts"
  add_foreign_key "account_lockouts", "accounts", column: "id"
  add_foreign_key "account_login_change_keys", "accounts", column: "id"
  add_foreign_key "account_login_failures", "accounts", column: "id"
  add_foreign_key "account_password_reset_keys", "accounts", column: "id"
  add_foreign_key "account_verification_keys", "accounts", column: "id"
  add_foreign_key "blob_aggregates", "accounts", column: "created_by_id"
  add_foreign_key "blob_aggregates", "accounts", column: "deleted_by_id"
  add_foreign_key "blob_aggregates", "accounts", column: "updated_by_id"
  add_foreign_key "db_storages", "accounts", column: "created_by_id"
  add_foreign_key "db_storages", "accounts", column: "deleted_by_id"
  add_foreign_key "db_storages", "accounts", column: "updated_by_id"
  add_foreign_key "db_storages", "blob_aggregates", column: "blob_id"
  add_foreign_key "ftp_storages", "accounts", column: "created_by_id"
  add_foreign_key "ftp_storages", "accounts", column: "deleted_by_id"
  add_foreign_key "ftp_storages", "accounts", column: "updated_by_id"
  add_foreign_key "ftp_storages", "blob_aggregates", column: "blob_id"
  add_foreign_key "local_storages", "accounts", column: "created_by_id"
  add_foreign_key "local_storages", "accounts", column: "deleted_by_id"
  add_foreign_key "local_storages", "accounts", column: "updated_by_id"
  add_foreign_key "local_storages", "blob_aggregates", column: "blob_id"
  add_foreign_key "s3_storages", "accounts", column: "created_by_id"
  add_foreign_key "s3_storages", "accounts", column: "deleted_by_id"
  add_foreign_key "s3_storages", "accounts", column: "updated_by_id"
  add_foreign_key "s3_storages", "blob_aggregates", column: "blob_id"
end
