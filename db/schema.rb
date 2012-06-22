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

ActiveRecord::Schema.define(:version => 20120622025012) do

  create_table "enquiries", :force => true do |t|
    t.integer  "user_id"
    t.integer  "provider_id"
    t.string   "provider_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.date     "date"
  end

  add_index "enquiries", ["provider_id", "provider_type"], :name => "index_enquiries_on_provider_id_and_provider_type"
  add_index "enquiries", ["user_id"], :name => "index_enquiries_on_user_id"

  create_table "enquiries_pets", :force => true do |t|
    t.integer "enquiry_id"
    t.integer "pet_id"
  end

  add_index "enquiries_pets", ["enquiry_id"], :name => "index_enquiries_pets_on_enquiry_id"
  add_index "enquiries_pets", ["pet_id"], :name => "index_enquiries_pets_on_pet_id"

  create_table "hotels", :force => true do |t|
    t.string   "title"
    t.string   "location"
    t.integer  "price"
    t.text     "description"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "user_id"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "address_suburb"
    t.string   "address_city"
    t.string   "address_postcode"
    t.integer  "cost_per_night"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address_country"
  end

  create_table "pets", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "type"
    t.string   "breed"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "pets", ["user_id"], :name => "index_pets_on_user_id"

  create_table "pictures", :force => true do |t|
    t.string   "file_uid"
    t.integer  "picturable_id"
    t.string   "picturable_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "ratings", :force => true do |t|
    t.integer  "stars"
    t.text     "review"
    t.integer  "user_id"
    t.integer  "ratable_id"
    t.string   "ratable_type"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "ratings", ["ratable_id", "ratable_type"], :name => "index_ratings_on_ratable_id_and_ratable_type"
  add_index "ratings", ["user_id"], :name => "index_ratings_on_user_id"

  create_table "sitters", :force => true do |t|
    t.string   "title"
    t.string   "location"
    t.integer  "price"
    t.text     "description"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "user_id"
    t.integer  "cost_per_night"
    t.integer  "distance"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                          :default => "", :null => false
    t.string   "encrypted_password",             :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                  :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.boolean  "wants_to_be_sitter"
    t.boolean  "wants_to_be_hotel"
    t.boolean  "wants_to_be_professional_hotel"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "address_suburb"
    t.string   "address_city"
    t.string   "address_postcode"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address_country"
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
