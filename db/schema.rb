ActiveRecord::Schema.define(version: 2019_07_03_044027) do
  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
