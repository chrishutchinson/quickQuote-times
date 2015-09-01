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

ActiveRecord::Schema.define(version: 20150803185535) do

  create_table "lines", force: :cascade do |t|
    t.integer  "transcription_id", limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "lines", ["transcription_id"], name: "index_lines_on_transcription_id", using: :btree

  create_table "quotes", force: :cascade do |t|
    t.float    "tc_in",                limit: 24
    t.float    "tc_out",               limit: 24
    t.float    "duration",             limit: 24
    t.text     "text",                 limit: 65535
    t.integer  "video_id",             limit: 4
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "author",               limit: 255
    t.string   "snippet_file_name",    limit: 255
    t.string   "snippet_content_type", limit: 255
    t.integer  "snippet_file_size",    limit: 4
    t.datetime "snippet_updated_at"
    t.string   "link",                 limit: 255
  end

  add_index "quotes", ["video_id"], name: "index_quotes_on_video_id", using: :btree

  create_table "transcriptions", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.integer  "video_id",    limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "transcriptions", ["video_id"], name: "index_transcriptions_on_video_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "token",      limit: 255
    t.string   "uid",        limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "videos", force: :cascade do |t|
    t.string   "link",               limit: 255
    t.string   "title",              limit: 255
    t.datetime "published_at"
    t.string   "uid",                limit: 255
    t.integer  "user_id",            limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "media_file_name",    limit: 255
    t.string   "media_content_type", limit: 255
    t.integer  "media_file_size",    limit: 4
    t.datetime "media_updated_at"
    t.boolean  "is_processed",       limit: 1
  end

  add_index "videos", ["uid"], name: "index_videos_on_uid", using: :btree
  add_index "videos", ["user_id"], name: "index_videos_on_user_id", using: :btree

  create_table "words", force: :cascade do |t|
    t.float    "tc_in",      limit: 24
    t.float    "tc_out",     limit: 24
    t.string   "word",       limit: 255
    t.integer  "line_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "words", ["line_id"], name: "index_words_on_line_id", using: :btree

  add_foreign_key "lines", "transcriptions"
  add_foreign_key "quotes", "videos"
  add_foreign_key "transcriptions", "videos"
  add_foreign_key "videos", "users", name: "videos_ibfk_1"
  add_foreign_key "words", "lines"
end
