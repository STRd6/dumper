# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170126184737) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "accounts", force: :cascade do |t|
    t.boolean  "verified",         default: false,                       null: false
    t.string   "email",                                                  null: false
    t.string   "domain",                                                 null: false
    t.uuid     "perishable_token", default: -> { "uuid_generate_v4()" }, null: false
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
  end

  create_table "contents", force: :cascade do |t|
    t.string   "sha256",     limit: 64, null: false
    t.string   "mime_type",             null: false
    t.integer  "size",                  null: false
    t.json     "meta"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "tokens", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer  "account_id",                 null: false
    t.boolean  "expired",    default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["account_id"], name: "index_tokens_on_account_id", using: :btree
  end

  add_foreign_key "tokens", "accounts"
end
