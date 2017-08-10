# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20170810072042) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "countries", force: true do |t|
    t.text     "display_name",                 null: false
    t.text     "key",                          null: false
    t.boolean  "default",      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "countries", ["display_name"], name: "index_countries_on_display_name", unique: true, using: :btree
  add_index "countries", ["key"], name: "index_countries_on_key", unique: true, using: :btree

  create_table "oauth_accounts", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "image_url"
    t.string   "profile_url"
    t.string   "access_token"
    t.text     "raw_data"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "secret"
  end

  add_index "oauth_accounts", ["user_id"], name: "index_oauth_accounts_on_user_id", using: :btree

  create_table "resumes", force: true do |t|
    t.string   "name"
    t.string   "attachment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "first_name",      default: "", null: false
    t.string   "last_name",       default: "", null: false
    t.string   "email",           default: "", null: false
    t.string   "password_digest", default: "", null: false
    t.string   "auth_token",      default: "", null: false
    t.string   "city",            default: "", null: false
    t.string   "state",           default: "", null: false
    t.string   "country",         default: "", null: false
    t.datetime "last_login_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["auth_token"], name: "index_users_on_auth_token", unique: true, using: :btree
  add_index "users", ["city"], name: "index_users_on_city", using: :btree
  add_index "users", ["country"], name: "index_users_on_country", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["first_name"], name: "index_users_on_first_name", using: :btree
  add_index "users", ["last_name"], name: "index_users_on_last_name", using: :btree
  add_index "users", ["state"], name: "index_users_on_state", using: :btree

end
