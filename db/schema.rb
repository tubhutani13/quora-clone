# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_03_16_114808) do
  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "answers", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "question_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "published_at"
    t.integer "upvote_count", default: 0
    t.integer "downvote_count", default: 0
    t.index ["question_id"], name: "index_answers_on_question_id"
    t.index ["user_id"], name: "index_answers_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.string "commentable_type", null: false
    t.integer "commentable_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "published_at"
    t.integer "upvote_count", default: 0
    t.integer "downvote_count", default: 0
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "credit_packs", force: :cascade do |t|
    t.decimal "price", precision: 7, scale: 2
    t.integer "credits"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "credits", force: :cascade do |t|
    t.integer "amount"
    t.integer "description"
    t.integer "user_id", null: false
    t.string "creditable_type", null: false
    t.integer "creditable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creditable_type", "creditable_id"], name: "index_credits_on_creditable"
    t.index ["user_id"], name: "index_credits_on_user_id"
  end

  create_table "follows", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.string "content"
    t.string "notifiable_type", null: false
    t.integer "notifiable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable"
  end

  create_table "notifications_users", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "notification_id", null: false
    t.boolean "sent"
    t.datetime "read_at"
    t.index ["notification_id", "user_id"], name: "index_notifications_users_on_notification_id_and_user_id"
    t.index ["user_id", "notification_id"], name: "index_notifications_users_on_user_id_and_notification_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "code"
    t.decimal "amount", precision: 7, scale: 2
    t.integer "status"
    t.integer "user_id", null: false
    t.integer "credit_pack_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["credit_pack_id"], name: "index_orders_on_credit_pack_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "title"
    t.string "permalink"
    t.datetime "published_at"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_questions_on_user_id"
  end

  create_table "reports", force: :cascade do |t|
    t.string "reason", null: false
    t.integer "user_id", null: false
    t.string "reportable_type", null: false
    t.integer "reportable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reportable_type", "reportable_id"], name: "index_reports_on_reportable"
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at", precision: nil
    t.string "tenant", limit: 128
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
    t.index ["tagger_type", "tagger_id"], name: "index_taggings_on_tagger_type_and_tagger_id"
    t.index ["tenant"], name: "index_taggings_on_tenant"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "transactions", force: :cascade do |t|
    t.string "transaction_id", null: false
    t.decimal "amount", null: false
    t.string "payment_method", null: false
    t.string "payment_status", null: false
    t.string "reason"
    t.string "status"
    t.integer "order_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_transactions_on_order_id"
    t.index ["transaction_id"], name: "index_transactions_on_transaction_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.integer "role", default: 0, null: false
    t.datetime "verified_at"
    t.string "email_confirm_token"
    t.string "password_reset_token"
    t.string "password_reset_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "credits_count", default: 0
    t.string "auth_token"
    t.datetime "disabled_at"
  end

  create_table "votes", force: :cascade do |t|
    t.integer "amount"
    t.string "voteable_type", null: false
    t.integer "voteable_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_votes_on_user_id"
    t.index ["voteable_type", "voteable_id"], name: "index_votes_on_voteable"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "users"
  add_foreign_key "comments", "users"
  add_foreign_key "credits", "users"
  add_foreign_key "orders", "credit_packs"
  add_foreign_key "orders", "users"
  add_foreign_key "questions", "users"
  add_foreign_key "reports", "users"
  add_foreign_key "taggings", "tags"
  add_foreign_key "transactions", "orders"
  add_foreign_key "votes", "users"
end
