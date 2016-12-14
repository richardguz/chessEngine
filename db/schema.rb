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

ActiveRecord::Schema.define(version: 20161214042424) do

  create_table "games", force: :cascade do |t|
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.         "board"
    t.string   "player1_token"
    t.string   "player2_token"
    t.boolean  "player1_turn"
    t.boolean  "white_can_castle_king_side",  default: true
    t.boolean  "black_can_castle_king_side",  default: true
    t.boolean  "white_can_castle_queen_side", default: true
    t.boolean  "black_can_castle_queen_side", default: true
  end

end
