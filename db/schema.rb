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

ActiveRecord::Schema.define(version: 20160506003104) do

  create_table "messages", force: :cascade do |t|
    t.string   "title"
    t.string   "user_id"
    t.string   "url"
    t.string   "source"
    t.text     "description"
    t.string   "msg_type"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "oauth_tokens", force: :cascade do |t|
    t.string   "token_string"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.datetime "valid_until"
    t.integer  "user_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.string  "token_string"
    t.integer "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
