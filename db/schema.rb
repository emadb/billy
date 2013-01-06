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

ActiveRecord::Schema.define(:version => 20130106142033) do

  create_table "customers", :force => true do |t|
    t.string   "name"
    t.string   "vat_code"
    t.string   "email"
    t.string   "address_street"
    t.string   "address_zip_code"
    t.string   "address_city"
    t.string   "address_province"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "file_name_template"
  end

  create_table "inbound_invoices", :force => true do |t|
    t.string   "customer"
    t.string   "number"
    t.date     "date"
    t.date     "due_date"
    t.float    "total"
    t.float    "tax"
    t.float    "taxable_income"
    t.text     "notes"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "invoice_items", :force => true do |t|
    t.string   "description"
    t.float    "amount"
    t.integer  "invoice_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "invoice_items", ["invoice_id"], :name => "index_invoice_items_on_invoice_id"

  create_table "invoices", :force => true do |t|
    t.integer  "number"
    t.date     "date"
    t.date     "due_date"
    t.integer  "status"
    t.float    "total"
    t.float    "tax"
    t.float    "taxable_income"
    t.boolean  "has_tax"
    t.text     "notes"
    t.boolean  "is_payed"
    t.integer  "customer_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "invoices", ["customer_id"], :name => "index_invoices_on_customer_id"

  create_table "job_order_activities", :force => true do |t|
    t.string   "description"
    t.integer  "estimated_hours"
    t.integer  "job_order_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.boolean  "active"
  end

  add_index "job_order_activities", ["job_order_id"], :name => "index_job_order_activities_on_job_order_id"

  create_table "job_orders", :force => true do |t|
    t.string   "code"
    t.text     "notes"
    t.float    "hourly_rate"
    t.boolean  "archived"
    t.integer  "customer_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "job_orders", ["customer_id"], :name => "index_job_orders_on_customer_id"

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 5
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "user_activities", :force => true do |t|
    t.integer  "user_id"
    t.integer  "job_order_activity_id"
    t.integer  "user_activity_type_id"
    t.date     "date"
    t.float    "hours"
    t.string   "description"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "user_activities", ["job_order_activity_id"], :name => "index_user_activities_on_job_order_activity_id"
  add_index "user_activities", ["user_activity_type_id"], :name => "index_user_activities_on_activity_type_id"
  add_index "user_activities", ["user_id"], :name => "index_user_activities_on_user_id"

  create_table "user_activity_types", :force => true do |t|
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
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
    t.boolean  "admin"
    t.string   "name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
