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

ActiveRecord::Schema.define(version: 20160712201702) do

  create_table "elevator_controllers", force: :cascade do |t|
    t.integer  "floors",             null: false
    t.integer  "elevator_count",     null: false
    t.integer  "last_used_elevator"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "elevator_requested_floors", force: :cascade do |t|
    t.integer  "floor"
    t.integer  "elevator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "elevator_requested_floors", ["elevator_id"], name: "index_elevator_requested_floors_on_elevator_id"

  create_table "elevators", force: :cascade do |t|
    t.integer  "number"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "current_floor",          default: 0
    t.string   "direction",              default: "UP"
    t.integer  "floors"
    t.integer  "elevator_controller_id"
  end

  add_index "elevators", ["elevator_controller_id"], name: "index_elevators_on_elevator_controller_id"

end
