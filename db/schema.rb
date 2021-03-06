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

ActiveRecord::Schema.define(version: 20160516061937) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "documents", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "country_code", default: "DE",                                   null: false
    t.uuid     "subject_id",   default: "110118bc-316e-11e6-b8e2-c715121d5b6f", null: false
    t.string   "subject_type", default: "Loan",                                 null: false
    t.string   "category"
    t.integer  "year"
    t.string   "owner",        default: "system",                               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "versions", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "document_id"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.bigint   "file_file_size"
    t.datetime "file_updated_at"
    t.string   "file_fingerprint"
    t.string   "uploaded_by",       default: "system",         null: false
    t.string   "reason",            default: "inital version", null: false
    t.datetime "version"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
