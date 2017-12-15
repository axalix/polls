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

ActiveRecord::Schema.define(version: 20150120221235) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: true do |t|
    t.integer  "user_id",                               null: false
    t.integer  "commented_obj_id"
    t.string   "commented_obj_type"
    t.text     "text",                                  null: false
    t.string   "status",             default: "active", null: false
    t.integer  "num_votes",          default: 0
    t.integer  "total_score",        default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commented_obj_id", "commented_obj_type"], name: "index_comments_on_commented_obj_id_and_commented_obj_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "dating_sites", force: true do |t|
    t.string "code",                                     null: false
    t.string "name",      limit: 128,                    null: false
    t.string "url",                                      null: false
    t.string "image_url",                                null: false
    t.text   "keywords",              default: ""
    t.string "status",                default: "active", null: false
  end

  create_table "notes", force: true do |t|
    t.integer  "user_id",                       null: false
    t.string   "kind",                          null: false
    t.string   "source",                        null: false
    t.text     "text",                          null: false
    t.string   "status",     default: "active", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notes", ["user_id"], name: "index_notes_on_user_id", using: :btree

  create_table "ratings", force: true do |t|
    t.integer  "user_id",                    null: false
    t.integer  "rated_obj_id"
    t.string   "rated_obj_type"
    t.integer  "score",          default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratings", ["rated_obj_id", "rated_obj_type"], name: "index_ratings_on_rated_obj_id_and_rated_obj_type", using: :btree
  add_index "ratings", ["user_id"], name: "index_ratings_on_user_id", using: :btree

  create_table "survey_entities", force: true do |t|
    t.integer  "survey_id"
    t.integer  "image_id"
    t.text     "text"
    t.integer  "num_votes",  default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "survey_entities", ["image_id"], name: "index_survey_entities_on_image_id", using: :btree

  create_table "survey_votes", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "survey_id",        null: false
    t.integer  "survey_entity_id", null: false
    t.integer  "user_id"
    t.string   "remote_ip",        null: false
  end

  add_index "survey_votes", ["survey_id", "survey_entity_id"], name: "index_survey_votes_on_survey_id_and_survey_entity_id", using: :btree
  add_index "survey_votes", ["survey_id", "user_id"], name: "index_survey_votes_on_survey_id_and_user_id", unique: true, using: :btree
  add_index "survey_votes", ["survey_id"], name: "index_survey_votes_on_survey_id", using: :btree
  add_index "survey_votes", ["user_id"], name: "index_survey_votes_on_user_id", using: :btree

  create_table "surveys", force: true do |t|
    t.string   "kind",                                                null: false
    t.string   "status",                                              null: false
    t.string   "url_hash",            limit: 128
    t.datetime "url_hash_expires_at"
    t.integer  "num_votes",                       default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",                                             null: false
    t.string   "publicity_status",                default: "private", null: false
    t.integer  "public_votes_limit",              default: 0
    t.integer  "public_votes_done",               default: 0
  end

  add_index "surveys", ["url_hash"], name: "index_surveys_on_url_hash", unique: true, using: :btree
  add_index "surveys", ["user_id"], name: "index_surveys_on_user_id", using: :btree

  create_table "tags", force: true do |t|
    t.integer  "user_id",                            null: false
    t.integer  "tagged_obj_id"
    t.string   "tagged_obj_type"
    t.string   "text",                               null: false
    t.string   "status",          default: "active", null: false
    t.integer  "num_votes",       default: 0
    t.integer  "total_score",     default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["tagged_obj_id", "tagged_obj_type"], name: "index_tags_on_tagged_obj_id_and_tagged_obj_type", using: :btree
  add_index "tags", ["user_id"], name: "index_tags_on_user_id", using: :btree

  create_table "tinder_profiles", force: true do |t|
    t.string   "uid",                    null: false
    t.string   "name",       limit: 127, null: false
    t.text     "bio"
    t.datetime "birth_date"
    t.integer  "gender"
    t.string   "photo"
    t.float    "latitude",               null: false
    t.float    "longitude",              null: false
    t.float    "distance",               null: false
    t.text     "json",                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tinder_profiles", ["uid"], name: "index_tinder_profiles_on_uid", unique: true, using: :btree

  create_table "uploads", force: true do |t|
    t.string   "name"
    t.string   "resource_file_name"
    t.string   "resource_content_type"
    t.integer  "resource_file_size"
    t.datetime "resource_updated_at"
    t.string   "width"
    t.string   "height"
    t.string   "status",                default: "active", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "num_refs",              default: 0
  end

  add_index "uploads", ["user_id"], name: "index_uploads_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                              default: "", null: false
    t.string   "encrypted_password",                 default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "provider_user_id"
    t.string   "name",                   limit: 127
    t.text     "bio"
    t.datetime "birth_date"
    t.string   "gender"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "comments", "users", name: "comments_user_id_fk"

  add_foreign_key "notes", "users", name: "notes_user_id_fk"

  add_foreign_key "ratings", "users", name: "ratings_user_id_fk"

  add_foreign_key "survey_entities", "surveys", name: "survey_entities_survey_id_fk"
  add_foreign_key "survey_entities", "uploads", name: "survey_entities_upload_id_fk", column: "image_id"

  add_foreign_key "survey_votes", "survey_entities", name: "survey_votes_survey_entity_id_fk"
  add_foreign_key "survey_votes", "surveys", name: "survey_votes_survey_id_fk"
  add_foreign_key "survey_votes", "users", name: "survey_votes_user_id_fk"

  add_foreign_key "surveys", "users", name: "surveys_user_id_fk"

  add_foreign_key "tags", "users", name: "tags_user_id_fk"

  add_foreign_key "uploads", "users", name: "uploads_user_id_fk"

end
