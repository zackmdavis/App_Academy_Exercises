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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131009235305) do

  create_table "contact_shares", :force => true do |t|
    t.integer  "contact_id", :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "contact_shares", ["contact_id"], :name => "index_contact_shares_on_contact_id"
  add_index "contact_shares", ["user_id"], :name => "index_contact_shares_on_user_id"

  create_table "contacts", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "email",      :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "favorite"
  end

  add_index "contacts", ["email"], :name => "index_contacts_on_email"
  add_index "contacts", ["user_id"], :name => "index_contacts_on_user_id"

  create_table "group_memberships", :force => true do |t|
    t.integer  "group_id"
    t.integer  "contact_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "groups", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "email",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email"

end
