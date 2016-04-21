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

ActiveRecord::Schema.define(version: 20160421004614) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "read",           default: false
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "articles", force: :cascade do |t|
    t.text     "body"
    t.integer  "organization_id"
    t.string   "title"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: :cascade do |t|
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "event_name"
    t.datetime "day_time"
    t.string   "location_id"
    t.integer  "point_val"
    t.integer  "created_by"
    t.text     "description"
    t.string   "image"
    t.integer  "updated_by"
    t.datetime "end_time"
    t.integer  "recurring_id"
    t.integer  "organization_id"
    t.string   "slug"
  end

  add_index "events", ["location_id"], name: "index_events_on_location_id", using: :btree
  add_index "events", ["slug"], name: "index_events_on_slug", using: :btree

  create_table "events_rooms", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "events_rooms", ["event_id"], name: "index_events_rooms_on_event_id", using: :btree
  add_index "events_rooms", ["room_id"], name: "index_events_rooms_on_room_id", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

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
    t.string   "slug"
  end

  add_index "locations", ["slug"], name: "index_locations_on_slug", using: :btree

  create_table "logs", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "params"
    t.string   "path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "org_roles", force: :cascade do |t|
    t.integer "org_id"
    t.string  "name"
    t.text    "description"
    t.text    "permissions", default: [], array: true
  end

  create_table "organizations", force: :cascade do |t|
    t.string  "name"
    t.text    "summary"
    t.text    "description"
    t.string  "slug"
    t.boolean "active"
    t.string  "image"
    t.integer "created_by"
  end

  add_index "organizations", ["slug"], name: "index_organizations_on_slug", using: :btree

  create_table "organizations_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "organization_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "organizations_users", ["organization_id"], name: "index_organizations_users_on_organization_id", using: :btree
  add_index "organizations_users", ["user_id"], name: "index_organizations_users_on_user_id", using: :btree

  create_table "permissions", force: :cascade do |t|
    t.string   "name"
    t.string   "subject_class"
    t.text     "description"
    t.string   "action"
    t.integer  "subject_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "slug"
    t.string   "scope"
  end

  add_index "permissions", ["slug"], name: "index_permissions_on_slug", using: :btree

  create_table "permissions_roles", id: false, force: :cascade do |t|
    t.integer "role_id"
    t.integer "permission_id"
  end

  add_index "permissions_roles", ["permission_id"], name: "index_permissions_roles_on_permission_id", using: :btree
  add_index "permissions_roles", ["role_id"], name: "index_permissions_roles_on_role_id", using: :btree

  create_table "requests", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "organization_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "request_type"
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "description"
    t.string   "slug"
  end

  add_index "roles", ["slug"], name: "index_roles_on_slug", using: :btree

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
    t.string   "slug"
  end

  add_index "rooms", ["slug"], name: "index_rooms_on_slug", using: :btree

  create_table "saved_swipes", force: :cascade do |t|
    t.string   "gsw_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "user_events", force: :cascade do |t|
    t.integer  "attended_event_id"
    t.integer  "attendee_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "user_org_roles", force: :cascade do |t|
    t.integer "user_id"
    t.integer "org_role_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",              null: false
    t.string   "encrypted_password",     default: "",              null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,               null: false
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
    t.integer  "failed_attempts",        default: 0,               null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "user_type"
    t.hstore   "last_semester"
    t.hstore   "current_semester"
    t.string   "class_type"
    t.string   "name"
    t.string   "theme",                  default: "smart-style-5"
    t.string   "slug"
    t.text     "notification_settings"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", using: :btree

end
