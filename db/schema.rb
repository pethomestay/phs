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

ActiveRecord::Schema.define(:version => 20140527041516) do

  create_table "accounts", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "bank"
    t.string   "bsb"
    t.string   "account_number"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "blog_comments", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "email",      :null => false
    t.string   "website"
    t.text     "body",       :null => false
    t.integer  "post_id",    :null => false
    t.string   "state"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "blog_comments", ["post_id"], :name => "index_blog_comments_on_post_id"

  create_table "blog_posts", :force => true do |t|
    t.string   "title",                         :null => false
    t.text     "body",                          :null => false
    t.integer  "blogger_id"
    t.string   "blogger_type"
    t.integer  "comments_count", :default => 0, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "blog_posts", ["blogger_type", "blogger_id"], :name => "index_blog_posts_on_blogger_type_and_blogger_id"

  create_table "bookings", :force => true do |t|
    t.integer  "booker_id"
    t.integer  "bookee_id"
    t.text     "message"
    t.string   "pet_name"
    t.string   "guest_name"
    t.integer  "enquiry_id"
    t.integer  "homestay_id"
    t.date     "check_in_date"
    t.time     "check_in_time"
    t.date     "check_out_date"
    t.time     "check_out_time"
    t.integer  "number_of_nights", :default => 1
    t.float    "cost_per_night",   :default => 1.0
    t.float    "subtotal",         :default => 1.0
    t.float    "amount",           :default => 1.0
    t.boolean  "host_accepted",    :default => false
    t.boolean  "owner_accepted",   :default => false
    t.string   "status",           :default => "unfinished"
    t.text     "response_message"
    t.integer  "response_id",      :default => 0
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  create_table "cards", :force => true do |t|
    t.integer  "user_id"
    t.string   "card_number"
    t.string   "token"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_uid",                     :null => false
    t.string   "data_name",                    :null => false
    t.string   "data_mime_type"
    t.integer  "data_size"
    t.integer  "assetable_id"
    t.string   "assetable_type", :limit => 30
    t.string   "type",           :limit => 30
    t.integer  "data_width"
    t.integer  "data_height"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"

  create_table "enquiries", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "homestay_id"
    t.text     "message"
    t.boolean  "confirmed",           :default => false
    t.boolean  "owner_accepted",      :default => false
    t.boolean  "sent_feedback_email", :default => false
    t.integer  "duration_id"
    t.text     "response_message"
    t.integer  "response_id",         :default => 0
    t.date     "check_in_date"
    t.time     "check_in_time"
    t.date     "check_out_date"
    t.time     "check_out_time"
    t.boolean  "reuse_message"
  end

  add_index "enquiries", ["homestay_id"], :name => "index_enquiries_on_homestay_id"
  add_index "enquiries", ["response_id"], :name => "index_enquiries_on_response_id"
  add_index "enquiries", ["user_id"], :name => "index_enquiries_on_user_id"

  create_table "enquiries_pets", :force => true do |t|
    t.integer "enquiry_id"
    t.integer "pet_id"
  end

  add_index "enquiries_pets", ["enquiry_id"], :name => "index_enquiries_pets_on_enquiry_id"
  add_index "enquiries_pets", ["pet_id"], :name => "index_enquiries_pets_on_pet_id"

  create_table "favourites", :force => true do |t|
    t.integer  "user_id"
    t.integer  "homestay_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

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
    t.float    "cost_per_night"
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
    t.boolean  "pet_feeding",                       :default => false
    t.boolean  "pet_grooming",                      :default => false
    t.boolean  "pet_training",                      :default => false
    t.boolean  "pet_walking",                       :default => false
    t.boolean  "is_professional",                   :default => false
    t.boolean  "active",                            :default => false
    t.string   "slug"
    t.integer  "property_type_id"
    t.integer  "outdoor_area_id"
    t.boolean  "locked",                            :default => true
  end

  add_index "homestays", ["outdoor_area_id"], :name => "index_homestays_on_outdoor_area_id"
  add_index "homestays", ["property_type_id"], :name => "index_homestays_on_property_type_id"
  add_index "homestays", ["user_id"], :name => "index_homestays_on_user_id"

  create_table "mailboxes", :force => true do |t|
    t.integer  "host_mailbox_id"
    t.integer  "guest_mailbox_id"
    t.integer  "enquiry_id"
    t.integer  "booking_id"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.boolean  "host_read",        :default => false
    t.boolean  "guest_read",       :default => false
  end

  create_table "messages", :force => true do |t|
    t.integer  "mailbox_id"
    t.integer  "user_id"
    t.text     "message_text"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

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
    t.string   "age"
    t.string   "microchip_number"
    t.string   "council_number"
    t.text     "explain_dislikes"
    t.string   "other_pet_type"
    t.string   "emergency_contact_name"
    t.string   "emergency_contact_phone"
    t.string   "vet_name"
    t.string   "vet_phone"
    t.text     "medication"
    t.date     "date_of_birth"
    t.integer  "pet_type_id"
    t.integer  "sex_id"
    t.integer  "size_id"
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

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], :name => "taggings_idx", :unique => true

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  add_index "tags", ["name"], :name => "index_tags_on_name", :unique => true

  create_table "transactions", :force => true do |t|
    t.integer  "booking_id"
    t.string   "transaction_id"
    t.string   "time_stamp"
    t.string   "merchant_fingerprint"
    t.string   "pre_authorisation_id"
    t.string   "response_text"
    t.float    "amount"
    t.string   "secure_pay_fingerprint"
    t.string   "reference"
    t.string   "type_code"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "storage_text"
    t.string   "status"
    t.integer  "card_id"
  end

  create_table "unavailable_dates", :force => true do |t|
    t.date     "date"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "unavailable_dates", ["user_id"], :name => "index_unavailable_dates_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
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
    t.boolean  "admin",                  :default => false
    t.integer  "average_rating"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.boolean  "payor",                  :default => false
    t.string   "provider"
    t.string   "uid"
    t.integer  "age_range_min"
    t.integer  "age_range_max"
    t.string   "facebook_location"
    t.date     "calendar_updated_at"
  end

  add_index "users", ["admin"], :name => "index_users_on_admin"
  add_index "users", ["average_rating"], :name => "index_users_on_average_rating"
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
