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

ActiveRecord::Schema.define(version: 20141204170739) do

  create_table "contacts", force: true do |t|
    t.string   "first_name"
    t.string   "last_name",                 default: ""
    t.string   "email",                     default: ""
    t.string   "phone",                     default: ""
    t.string   "street",                    default: ""
    t.string   "city",                      default: ""
    t.string   "state",                     default: ""
    t.string   "zip",                       default: ""
    t.string   "country",                   default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "structured_postal_address", default: ""
  end

  add_index "contacts", ["user_id"], name: "index_contacts_on_user_id"

  create_table "users", force: true do |t|
    t.string   "username",                      null: false
    t.string   "name"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider_name",    default: ""
    t.string   "provider_uid",     default: ""
    t.string   "oauth_token",      default: ""
    t.datetime "oauth_expires_at"
  end

end
