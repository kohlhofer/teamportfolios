# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091026234634) do

  create_table "avatars", :force => true do |t|
    t.integer  "user_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contributions", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_addresses", :force => true do |t|
    t.string   "email"
    t.integer  "user_id"
    t.datetime "activation_at"
    t.string   "activation_code"
    t.datetime "activated_at"
    t.datetime "created_at"
    t.boolean  "primary",         :default => true
  end

  add_index "email_addresses", ["email"], :name => "index_email_addresses_on_email", :unique => true

  create_table "images", :force => true do |t|
    t.integer  "project_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.string   "caption"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", :force => true do |t|
    t.integer  "email_address_id"
    t.string   "action"
    t.datetime "attempted_send"
    t.string   "failure_msg"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_links", :force => true do |t|
    t.integer  "project_id"
    t.string   "url"
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "strapline"
  end

  create_table "unvalidated_contributors", :force => true do |t|
    t.integer  "project_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "email_address_id"
  end

  create_table "user_links", :force => true do |t|
    t.integer  "user_id"
    t.string   "url"
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "strapline"
    t.text     "bio"
    t.integer  "projects_count",                           :default => 0
    t.string   "reset_password_code"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
