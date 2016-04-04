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

ActiveRecord::Schema.define(version: 20160404161338) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "events", force: :cascade do |t|
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "event_name"
    t.string   "department"
    t.datetime "day_time"
    t.integer  "point_val"
    t.integer  "created_by"
    t.text     "description"
    t.string   "image"
    t.integer  "updated_by"
    t.integer  "location_id"
    t.datetime "end_time"
    t.integer  "recurring_id"
  end

  add_index "events", ["location_id"], name: "index_events_on_location_id", using: :btree

  create_table "events_rooms", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "events_rooms", ["event_id"], name: "index_events_rooms_on_event_id", using: :btree
  add_index "events_rooms", ["room_id"], name: "index_events_rooms_on_room_id", using: :btree

  create_table "host_events", force: :cascade do |t|
    t.integer  "hosted_event_id"
    t.integer  "host_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string   "building_name"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "rooms_count",   default: 0
  end

  create_table "logs", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "params"
    t.string   "path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "permissions", force: :cascade do |t|
    t.string   "name"
    t.string   "subject_class"
    t.text     "description"
    t.string   "action"
    t.integer  "subject_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "permissions_roles", id: false, force: :cascade do |t|
    t.integer "role_id"
    t.integer "permission_id"
  end

  add_index "permissions_roles", ["permission_id"], name: "index_permissions_roles_on_permission_id", using: :btree
  add_index "permissions_roles", ["role_id"], name: "index_permissions_roles_on_role_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "description"
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], name: "index_roles_users_on_role_id", using: :btree
  add_index "roles_users", ["user_id"], name: "index_roles_users_on_user_id", using: :btree

  create_table "rooms", force: :cascade do |t|
    t.integer  "location_id"
    t.string   "room_number"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "user_events", force: :cascade do |t|
    t.integer  "attended_event_id"
    t.integer  "attendee_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                         default: "",              null: false
    t.string   "encrypted_password",            default: "",              null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                 default: 0,               null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "gsw_pin"
    t.string   "gsw_id"
    t.integer  "points"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",               default: 0,               null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "user_type"
    t.hstore   "last_semester"
    t.hstore   "current_semester"
    t.string   "class_type"
    t.string   "name"
    t.string   "encrypted_current_semester_iv"
    t.string   "encrypted_last_semester_iv"
    t.string   "theme",                         default: "smart-style-5"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
