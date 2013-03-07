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

ActiveRecord::Schema.define(:version => 20130307083251) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "enquiries", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.date     "date"
    t.integer  "homestay_id"
    t.text     "message"
    t.boolean  "responded",           :default => false
    t.boolean  "accepted",            :default => false
    t.boolean  "confirmed",           :default => false
    t.boolean  "owner_accepted",      :default => false
    t.boolean  "sent_feedback_email", :default => false
    t.integer  "duration_id"
  end

  add_index "enquiries", ["homestay_id"], :name => "index_enquiries_on_homestay_id"
  add_index "enquiries", ["user_id"], :name => "index_enquiries_on_user_id"

  create_table "enquiries_pets", :force => true do |t|
    t.integer "enquiry_id"
    t.integer "pet_id"
  end

  add_index "enquiries_pets", ["enquiry_id"], :name => "index_enquiries_pets_on_enquiry_id"
  add_index "enquiries_pets", ["pet_id"], :name => "index_enquiries_pets_on_pet_id"

  create_table "feedbacks", :force => true do |t|
    t.integer  "user_id"
    t.integer  "subject_id"
    t.integer  "enquiry_id"
    t.integer  "rating"
    t.text     "review"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "feedbacks", ["enquiry_id"], :name => "index_feedbacks_on_enquiry_id"
  add_index "feedbacks", ["subject_id"], :name => "index_feedbacks_on_subject_id"
  add_index "feedbacks", ["user_id"], :name => "index_feedbacks_on_user_id"

  create_table "homestays", :force => true do |t|
    t.string   "title"
    t.integer  "cost_per_night"
    t.text     "description"
    t.integer  "user_id"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "address_suburb"
    t.string   "address_city"
    t.string   "address_postcode"
    t.string   "address_country"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.boolean  "constant_supervision",              :default => false
    t.boolean  "emergency_transport",               :default => false
    t.boolean  "first_aid",                         :default => false
    t.boolean  "insurance",                         :default => false
    t.boolean  "professional_qualification",        :default => false
    t.string   "professional_qualification_detail"
    t.string   "years_looking_after_pets"
    t.string   "website"
    t.boolean  "pets_present",                      :default => false
    t.boolean  "fenced",                            :default => false
    t.boolean  "supervision_outside_work_hours",    :default => false
    t.boolean  "police_check",                      :default => false
    t.boolean  "children_present",                  :default => false
    t.string   "outdoor_area"
    t.string   "property_type"
    t.boolean  "pet_feeding",                       :default => false
    t.boolean  "pet_grooming",                      :default => false
    t.boolean  "pet_training",                      :default => false
    t.boolean  "pet_walking",                       :default => false
    t.boolean  "is_professional",                   :default => false
    t.boolean  "active",                            :default => true
    t.string   "slug"
  end

  add_index "homestays", ["user_id"], :name => "index_homestays_on_user_id"

  create_table "pets", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "breed"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.boolean  "dislike_loneliness"
    t.boolean  "dislike_children"
    t.boolean  "dislike_animals"
    t.boolean  "dislike_people"
    t.boolean  "flea_treated",            :default => false
    t.boolean  "vaccinated",              :default => false
    t.boolean  "house_trained",           :default => false
    t.string   "sex"
    t.string   "age"
    t.string   "microchip_number"
    t.string   "council_number"
    t.string   "size"
    t.text     "explain_dislikes"
    t.string   "other_pet_type"
    t.string   "emergency_contact_name"
    t.string   "emergency_contact_phone"
    t.string   "vet_name"
    t.string   "vet_phone"
    t.text     "medication"
    t.date     "date_of_birth"
    t.integer  "pet_type_id"
  end

  add_index "pets", ["pet_type_id"], :name => "index_pets_on_pet_type_id"
  add_index "pets", ["user_id"], :name => "index_pets_on_user_id"

  create_table "pictures", :force => true do |t|
    t.string   "file_uid"
    t.integer  "picturable_id"
    t.string   "picturable_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",   :null => false
    t.string   "encrypted_password",     :default => "",   :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.date     "date_of_birth"
    t.string   "phone_number"
    t.string   "mobile_number"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "address_suburb"
    t.string   "address_city"
    t.string   "address_postcode"
    t.string   "address_country"
    t.boolean  "active",                 :default => true
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
