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

ActiveRecord::Schema.define(version: 20150511110406) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body"
    t.string   "resource_id",   limit: 255, null: false
    t.string   "resource_type", limit: 255, null: false
    t.integer  "author_id",     limit: 11
    t.string   "author_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "active_admin_comments_index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["id"], name: "sqlite_autoindex_active_admin_comments_1", unique: true
  add_index "active_admin_comments", ["namespace"], name: "active_admin_comments_index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "active_admin_comments_index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "admin_comments", force: :cascade do |t|
    t.integer  "commentable_id",   limit: 11
    t.string   "commentable_type", limit: 255
    t.integer  "author_id",        limit: 11
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_comments", ["id"], name: "sqlite_autoindex_admin_comments_1", unique: true

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 11,  default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "admin_users_index_admin_users_on_email"
  add_index "admin_users", ["id"], name: "sqlite_autoindex_admin_users_1", unique: true
  add_index "admin_users", ["reset_password_token"], name: "admin_users_index_admin_users_on_reset_password_token"

  create_table "allowed_cities", force: :cascade do |t|
    t.integer  "petition_type_id", limit: 11
    t.integer  "city_id",          limit: 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "allowed_cities", ["city_id"], name: "allowed_cities_index_allowed_cities_on_city_id"
  add_index "allowed_cities", ["id"], name: "sqlite_autoindex_allowed_cities_1", unique: true
  add_index "allowed_cities", ["petition_type_id"], name: "allowed_cities_index_allowed_cities_on_petition_type_id"

  create_table "cities", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.datetime "imported_at"
    t.string   "imported_from", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cities", ["id"], name: "sqlite_autoindex_cities_1", unique: true

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 11,  default: 0
    t.integer  "attempts",   limit: 11,  default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["id"], name: "sqlite_autoindex_delayed_jobs_1", unique: true

  create_table "faqs", force: :cascade do |t|
    t.string   "question",    limit: 255
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug", limit: 255
  end

  add_index "faqs", ["cached_slug"], name: "faqs_index_faqs_on_cached_slug"
  add_index "faqs", ["id"], name: "sqlite_autoindex_faqs_1", unique: true

  create_table "feedbacks", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "email",             limit: 255
    t.string   "subject",           limit: 255
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "feedbackable_id",   limit: 11
    t.string   "feedbackable_type", limit: 255
    t.string   "recipient_email",   limit: 255
  end

  add_index "feedbacks", ["created_at"], name: "feedbacks_index_feedbacks_on_created_at"
  add_index "feedbacks", ["email"], name: "feedbacks_index_feedbacks_on_email"
  add_index "feedbacks", ["id"], name: "sqlite_autoindex_feedbacks_1", unique: true
  add_index "feedbacks", ["name"], name: "feedbacks_index_feedbacks_on_name"

  create_table "images", force: :cascade do |t|
    t.integer  "imageable_id",        limit: 11
    t.string   "imageable_type",      limit: 255
    t.string   "upload_file_name",    limit: 255
    t.string   "upload_content_type", limit: 255
    t.integer  "upload_file_size",    limit: 11
    t.datetime "upload_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "alt_label",           limit: 255
  end

  add_index "images", ["id"], name: "sqlite_autoindex_images_1", unique: true
  add_index "images", ["imageable_id"], name: "images_index_images_on_imageable_id"
  add_index "images", ["imageable_type"], name: "images_index_images_on_imageable_type"

  create_table "initiations", force: :cascade do |t|
    t.string   "email",       limit: 255
    t.string   "unique_key",  limit: 255
    t.string   "name",        limit: 255
    t.integer  "petition_id", limit: 11
    t.integer  "office_id",   limit: 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "initiations", ["id"], name: "sqlite_autoindex_initiations_1", unique: true

  create_table "new_signatures", force: :cascade do |t|
    t.integer  "petition_id",                 limit: 11,  default: 0, null: false
    t.string   "person_name",                 limit: 255
    t.string   "person_street",               limit: 255
    t.string   "person_street_number_suffix", limit: 255
    t.string   "person_street_number",        limit: 255
    t.string   "person_postalcode",           limit: 255
    t.string   "person_function",             limit: 255
    t.string   "person_email",                limit: 255
    t.integer  "person_dutch_citizen",        limit: 1
    t.datetime "signed_at"
    t.datetime "confirmed_at"
    t.integer  "confirmed",                   limit: 1,   default: 0, null: false
    t.string   "unique_key",                  limit: 255
    t.integer  "special",                     limit: 1
    t.string   "person_city",                 limit: 255
    t.integer  "subscribe",                   limit: 1,   default: 0
    t.string   "person_birth_date",           limit: 255
    t.string   "person_birth_city",           limit: 255
    t.integer  "sort_order",                  limit: 11,  default: 0, null: false
    t.string   "signature_remote_addr",       limit: 255
    t.string   "signature_remote_browser",    limit: 255
    t.string   "confirmation_remote_addr",    limit: 255
    t.string   "confirmation_remote_browser", limit: 255
    t.integer  "more_information",            limit: 1,   default: 0, null: false
    t.integer  "visible",                     limit: 1,   default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "person_born_at"
    t.integer  "reminders_sent",              limit: 11
    t.datetime "last_reminder_sent_at"
    t.date     "unconverted_person_born_at"
  end

  add_index "new_signatures", ["confirmed"], name: "new_signatures_confirmed"
  add_index "new_signatures", ["confirmed_at"], name: "new_signatures_date_confirmed"
  add_index "new_signatures", ["id"], name: "sqlite_autoindex_new_signatures_1", unique: true
  add_index "new_signatures", ["person_email"], name: "new_signatures_person_email"
  add_index "new_signatures", ["person_function"], name: "new_signatures_person_function"
  add_index "new_signatures", ["petition_id", "special"], name: "new_signatures_index_signatures_on_petiton_id_and_special"
  add_index "new_signatures", ["petition_id"], name: "new_signatures_petition_id"
  add_index "new_signatures", ["signed_at"], name: "new_signatures_index_signatures_on_signed_at"
  add_index "new_signatures", ["sort_order"], name: "new_signatures_sort_order"
  add_index "new_signatures", ["special"], name: "new_signatures_index_signatures_on_special"
  add_index "new_signatures", ["subscribe"], name: "new_signatures_subscribe"
  add_index "new_signatures", ["unique_key"], name: "new_signatures_unique_key"

  create_table "newsitems", force: :cascade do |t|
    t.string   "title",          limit: 255
    t.string   "title_clean",    limit: 255
    t.text     "text"
    t.integer  "petition_id",    limit: 11
    t.integer  "office_id",      limit: 11
    t.string   "url",            limit: 255
    t.string   "url_text",       limit: 255
    t.string   "private_key",    limit: 255
    t.date     "date"
    t.date     "date_from"
    t.date     "date_until"
    t.integer  "show_on_office", limit: 1
    t.integer  "show_on_home",   limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug",    limit: 255
  end

  add_index "newsitems", ["cached_slug"], name: "newsitems_index_newsitems_on_cached_slug"
  add_index "newsitems", ["date_from"], name: "newsitems_index_newsitems_on_date_from"
  add_index "newsitems", ["date_until"], name: "newsitems_index_newsitems_on_date_until"
  add_index "newsitems", ["id"], name: "sqlite_autoindex_newsitems_1", unique: true
  add_index "newsitems", ["office_id"], name: "newsitems_index_newsitems_on_office_id"
  add_index "newsitems", ["petition_id"], name: "newsitems_index_newsitems_on_petition_id"

  create_table "newsletters", force: :cascade do |t|
    t.integer  "petition_id",                limit: 11
    t.integer  "number",                     limit: 11
    t.string   "status",                     limit: 255
    t.integer  "published",                  limit: 1,   default: 0, null: false
    t.datetime "publish_from"
    t.integer  "creating_messages",          limit: 1,   default: 0, null: false
    t.integer  "messages_created",           limit: 1,   default: 0, null: false
    t.datetime "messages_created_at"
    t.integer  "number_of_messages_created", limit: 11
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by",                 limit: 11
    t.integer  "approved_by",                limit: 11
    t.date     "date"
  end

  add_index "newsletters", ["id"], name: "sqlite_autoindex_newsletters_1", unique: true
  add_index "newsletters", ["petition_id"], name: "newsletters_index_newsletters_on_petition_id"
  add_index "newsletters", ["publish_from"], name: "newsletters_index_newsletters_on_publish_from"
  add_index "newsletters", ["published"], name: "newsletters_index_newsletters_on_published"
  add_index "newsletters", ["status"], name: "newsletters_index_newsletters_on_status"

  create_table "offices", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "name_clean",        limit: 255
    t.text     "text"
    t.string   "url",               limit: 255
    t.integer  "hidden",            limit: 1
    t.string   "postalcode",        limit: 255
    t.string   "email",             limit: 255
    t.integer  "organisation_id",   limit: 11
    t.string   "organisation_kind", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug",       limit: 255
    t.string   "subdomain",         limit: 255
    t.string   "url_text",          limit: 255
    t.string   "telephone",         limit: 255
    t.integer  "petition_type_id",  limit: 11
  end

  add_index "offices", ["cached_slug"], name: "offices_index_offices_on_cached_slug"
  add_index "offices", ["hidden"], name: "offices_hidden"
  add_index "offices", ["id"], name: "sqlite_autoindex_offices_1", unique: true
  add_index "offices", ["name_clean"], name: "offices_name_clean"
  add_index "offices", ["subdomain"], name: "offices_index_offices_on_subdomain"

  create_table "organisations", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "kind",       limit: 255
    t.string   "code",       limit: 5
    t.string   "region",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "visible",    limit: 1
  end

  add_index "organisations", ["id"], name: "sqlite_autoindex_organisations_1", unique: true
  add_index "organisations", ["kind"], name: "organisations_type"
  add_index "organisations", ["name"], name: "organisations_name"
  add_index "organisations", ["visible"], name: "organisations_index_organisations_on_visible"

  create_table "pages", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.text     "content"
    t.string   "cached_slug", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["cached_slug"], name: "pages_index_pages_on_cached_slug"
  add_index "pages", ["id"], name: "sqlite_autoindex_pages_1", unique: true

  create_table "petition_translations", force: :cascade do |t|
    t.integer  "petition_id", limit: 11,  null: false
    t.string   "locale",      limit: 255, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "name",        limit: 255
    t.text     "description"
    t.text     "initiators"
    t.text     "statement"
    t.text     "request"
  end

  add_index "petition_translations", ["id"], name: "sqlite_autoindex_petition_translations_1", unique: true
  add_index "petition_translations", ["locale"], name: "petition_translations_index_petition_translations_on_locale"
  add_index "petition_translations", ["petition_id"], name: "petition_translations_index_petition_translations_on_petition_id"

  create_table "petition_types", force: :cascade do |t|
    t.string   "name",                                        limit: 255
    t.text     "description"
    t.integer  "required_minimum_age",                        limit: 11
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "display_person_born_at",                      limit: 1
    t.integer  "display_person_birth_city",                   limit: 1
    t.integer  "require_person_born_at",                      limit: 1
    t.integer  "require_person_birth_city",                   limit: 1
    t.integer  "display_signature_person_citizen",            limit: 1
    t.integer  "display_signature_full_address",              limit: 1
    t.integer  "require_signature_full_address",              limit: 1
    t.string   "custom_additional_info_visible",              limit: 255
    t.string   "custom_additional_info_person_name",          limit: 255
    t.string   "custom_additional_info_person_street",        limit: 255
    t.string   "custom_additional_info_person_postalcode",    limit: 255
    t.string   "custom_additional_info_person_function",      limit: 255
    t.string   "custom_additional_info_subscribe",            limit: 255
    t.string   "custom_additional_info_person_birth_date",    limit: 255
    t.string   "custom_additional_info_person_birth_city",    limit: 255
    t.string   "custom_additional_info_person_dutch_citizen", limit: 255
    t.string   "custom_additional_info_more_information",     limit: 255
  end

  add_index "petition_types", ["id"], name: "sqlite_autoindex_petition_types_1", unique: true

  create_table "petitions", force: :cascade do |t|
    t.string   "name",                             limit: 255
    t.string   "name_clean",                       limit: 255
    t.string   "subdomain",                        limit: 255
    t.text     "description"
    t.text     "initiators"
    t.text     "statement"
    t.text     "request"
    t.date     "date_projected"
    t.integer  "office_id",                        limit: 11
    t.integer  "organisation_id",                  limit: 11
    t.string   "organisation_name",                limit: 255
    t.string   "petitioner_organisation",          limit: 255
    t.date     "petitioner_birth_date"
    t.string   "petitioner_birth_city",            limit: 255
    t.string   "petitioner_name",                  limit: 255
    t.string   "petitioner_address",               limit: 255
    t.string   "petitioner_postalcode",            limit: 255
    t.string   "petitioner_city",                  limit: 255
    t.string   "petitioner_email",                 limit: 255
    t.string   "petitioner_telephone",             limit: 255
    t.string   "maps_query",                       limit: 255
    t.string   "office_suggestion",                limit: 255
    t.string   "organisation_kind",                limit: 255
    t.string   "link1",                            limit: 255
    t.string   "link2",                            limit: 255
    t.string   "link3",                            limit: 255
    t.string   "link1_text",                       limit: 255
    t.string   "link2_text",                       limit: 255
    t.string   "link3_text",                       limit: 255
    t.string   "site1",                            limit: 255
    t.string   "site1_text",                       limit: 255
    t.integer  "signatures_count",                 limit: 11,  default: 0, null: false
    t.integer  "number_of_signatures_on_paper",    limit: 11,  default: 0, null: false
    t.integer  "number_of_newsletters_sent",       limit: 11,  default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug",                      limit: 255
    t.datetime "last_confirmed_at"
    t.string   "status",                           limit: 255
    t.integer  "manager_id",                       limit: 11
    t.integer  "show_twitter",                     limit: 1
    t.integer  "show_history",                     limit: 1
    t.integer  "show_map",                         limit: 1
    t.string   "twitter_query",                    limit: 255
    t.string   "lat_lng",                          limit: 255
    t.string   "lat_lng_sw",                       limit: 255
    t.string   "lat_lng_ne",                       limit: 255
    t.integer  "special_count",                    limit: 11,  default: 0, null: false
    t.integer  "display_more_information",         limit: 1
    t.integer  "display_signature_person_citizen", limit: 1,   default: 0
    t.integer  "display_signature_full_address",   limit: 1,   default: 0
    t.integer  "archived",                         limit: 1,   default: 0
    t.integer  "petition_type_id",                 limit: 11
    t.integer  "display_person_born_at",           limit: 1
    t.integer  "display_person_birth_city",        limit: 1
    t.integer  "delta",                            limit: 1,   default: 1, null: false
    t.text     "locale_list"
  end

  add_index "petitions", ["cached_slug"], name: "petitions_index_petitions_on_cached_slug"
  add_index "petitions", ["date_projected"], name: "petitions_date_projected"
  add_index "petitions", ["id"], name: "sqlite_autoindex_petitions_1", unique: true
  add_index "petitions", ["last_confirmed_at"], name: "petitions_index_petitions_on_last_confirmed_at"
  add_index "petitions", ["lat_lng"], name: "petitions_index_petitions_on_lat_lng"
  add_index "petitions", ["name"], name: "petitions_name_2"
  add_index "petitions", ["name_clean"], name: "petitions_name_clean"
  add_index "petitions", ["office_id"], name: "petitions_office_id"
  add_index "petitions", ["petitioner_name"], name: "petitions_petitioner_name"
  add_index "petitions", ["status"], name: "petitions_index_petitions_on_status"

  create_table "progressions", force: :cascade do |t|
    t.integer  "petition_id",         limit: 11
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",              limit: 255
    t.integer  "user_id",             limit: 11
    t.integer  "send_update_message", limit: 1,   default: 1
    t.text     "public_comment"
  end

  add_index "progressions", ["id"], name: "sqlite_autoindex_progressions_1", unique: true
  add_index "progressions", ["petition_id"], name: "progressions_petition_id"
  add_index "progressions", ["status"], name: "progressions_index_progressions_on_status"
  add_index "progressions", ["updated_at"], name: "progressions_index_progressions_on_updated_at"

  create_table "roles", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "authorizable_type", limit: 255
    t.integer  "authorizable_id",   limit: 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["authorizable_id"], name: "roles_index_roles_on_authorizable_id"
  add_index "roles", ["authorizable_type"], name: "roles_index_roles_on_authorizable_type"
  add_index "roles", ["id"], name: "sqlite_autoindex_roles_1", unique: true

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer  "user_id",    limit: 11
    t.integer  "role_id",    limit: 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "signatures", force: :cascade do |t|
    t.integer  "petition_id",                 limit: 11,  default: 0, null: false
    t.string   "person_name",                 limit: 255
    t.string   "person_street",               limit: 255
    t.string   "person_street_number_suffix", limit: 255
    t.string   "person_street_number",        limit: 255
    t.string   "person_postalcode",           limit: 255
    t.string   "person_function",             limit: 255
    t.string   "person_email",                limit: 255
    t.integer  "person_dutch_citizen",        limit: 1
    t.datetime "signed_at"
    t.datetime "confirmed_at"
    t.integer  "confirmed",                   limit: 1,   default: 0, null: false
    t.string   "unique_key",                  limit: 255
    t.integer  "special",                     limit: 1
    t.string   "person_city",                 limit: 255
    t.integer  "subscribe",                   limit: 1,   default: 0
    t.string   "person_birth_date",           limit: 255
    t.string   "person_birth_city",           limit: 255
    t.integer  "sort_order",                  limit: 11,  default: 0, null: false
    t.string   "signature_remote_addr",       limit: 255
    t.string   "signature_remote_browser",    limit: 255
    t.string   "confirmation_remote_addr",    limit: 255
    t.string   "confirmation_remote_browser", limit: 255
    t.integer  "more_information",            limit: 1,   default: 0, null: false
    t.integer  "visible",                     limit: 1,   default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "person_born_at"
    t.integer  "reminders_sent",              limit: 11
    t.datetime "last_reminder_sent_at"
    t.date     "unconverted_person_born_at"
  end

  add_index "signatures", ["confirmed"], name: "signatures_confirmed"
  add_index "signatures", ["confirmed_at"], name: "signatures_date_confirmed"
  add_index "signatures", ["id"], name: "sqlite_autoindex_signatures_1", unique: true
  add_index "signatures", ["person_email"], name: "signatures_person_email"
  add_index "signatures", ["person_function"], name: "signatures_person_function"
  add_index "signatures", ["petition_id", "special"], name: "signatures_index_signatures_on_petiton_id_and_special"
  add_index "signatures", ["petition_id"], name: "signatures_petition_id"
  add_index "signatures", ["signed_at"], name: "signatures_index_signatures_on_signed_at"
  add_index "signatures", ["sort_order"], name: "signatures_sort_order"
  add_index "signatures", ["special"], name: "signatures_index_signatures_on_special"
  add_index "signatures", ["subscribe"], name: "signatures_subscribe"
  add_index "signatures", ["unique_key"], name: "signatures_unique_key"

  create_table "signatures_reconfirmations", force: :cascade do |t|
    t.integer  "signature_id",               limit: 11
    t.string   "phase",                      limit: 255
    t.string   "status",                     limit: 255
    t.string   "unique_key",                 limit: 255, null: false
    t.datetime "message_sent_at"
    t.integer  "reconfirmed",                limit: 1
    t.datetime "reconfirmed_at"
    t.string   "reconfirmed_remote_addr",    limit: 255
    t.string   "reconfirmed_remote_browser", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "signatures_reconfirmations", ["id"], name: "sqlite_autoindex_signatures_reconfirmations_1", unique: true
  add_index "signatures_reconfirmations", ["reconfirmed"], name: "signatures_reconfirmations_index_signatures_reconfirmations_on_reconfirmed"
  add_index "signatures_reconfirmations", ["signature_id"], name: "signatures_reconfirmations_index_signatures_reconfirmations_on_signature_id"
  add_index "signatures_reconfirmations", ["status"], name: "signatures_reconfirmations_index_signatures_reconfirmations_on_status"
  add_index "signatures_reconfirmations", ["unique_key"], name: "signatures_reconfirmations_index_signatures_reconfirmations_on_unique_key"

  create_table "slugs", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.integer  "sluggable_id",   limit: 11
    t.integer  "sequence",       limit: 11,  default: 1, null: false
    t.string   "sluggable_type", limit: 40
    t.string   "scope",          limit: 40
    t.datetime "created_at"
  end

  add_index "slugs", ["id"], name: "sqlite_autoindex_slugs_1", unique: true
  add_index "slugs", ["name", "sluggable_type", "sequence"], name: "slugs_index_slugs_on_n_s_s_and_s"
  add_index "slugs", ["sluggable_id"], name: "slugs_index_slugs_on_sluggable_id"

  create_table "statistics", force: :cascade do |t|
    t.integer  "statisticable_id",   limit: 11
    t.string   "statisticable_type", limit: 255
    t.string   "kind",               limit: 255
    t.string   "reporting_period",   limit: 255
    t.datetime "start_at"
    t.integer  "value",              limit: 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "statistics", ["id"], name: "sqlite_autoindex_statistics_1", unique: true

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        limit: 11
    t.integer  "taggable_id",   limit: 11
    t.integer  "tagger_id",     limit: 11
    t.string   "tagger_type",   limit: 40
    t.string   "taggable_type", limit: 40
    t.string   "context",       limit: 255
    t.datetime "created_at"
  end

  add_index "taggings", ["id"], name: "sqlite_autoindex_taggings_1", unique: true
  add_index "taggings", ["tag_id"], name: "taggings_index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "taggings_index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", force: :cascade do |t|
    t.string "name", limit: 255
  end

  add_index "tags", ["id"], name: "sqlite_autoindex_tags_1", unique: true

  create_table "tolk_locales", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tolk_locales", ["id"], name: "sqlite_autoindex_tolk_locales_1", unique: true
  add_index "tolk_locales", ["name"], name: "tolk_locales_index_tolk_locales_on_name"

  create_table "tolk_phrases", force: :cascade do |t|
    t.text     "key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tolk_phrases", ["id"], name: "sqlite_autoindex_tolk_phrases_1", unique: true

  create_table "tolk_translations", force: :cascade do |t|
    t.integer  "phrase_id",       limit: 11
    t.integer  "locale_id",       limit: 11
    t.text     "text"
    t.text     "previous_text"
    t.integer  "primary_updated", limit: 1,  default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tolk_translations", ["id"], name: "sqlite_autoindex_tolk_translations_1", unique: true
  add_index "tolk_translations", ["phrase_id", "locale_id"], name: "tolk_translations_index_tolk_translations_on_phrase_id_and_locale_id"

  create_table "users", force: :cascade do |t|
    t.string   "username",               limit: 255
    t.string   "name",                   limit: 255
    t.string   "email",                  limit: 255
    t.integer  "confirmed",              limit: 1,   default: 0, null: false
    t.string   "crypted_password",       limit: 255
    t.string   "password_salt",          limit: 255
    t.string   "persistence_token",      limit: 255
    t.string   "single_access_token",    limit: 255
    t.string   "perishable_token",       limit: 255
    t.integer  "login_count",            limit: 11,  default: 0, null: false
    t.integer  "failed_login_count",     limit: 11,  default: 0, null: false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip",       limit: 255
    t.string   "last_login_ip",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address",                limit: 255
    t.string   "postalcode",             limit: 255
    t.string   "city",                   limit: 255
    t.string   "telephone",              limit: 255
    t.date     "birth_date"
    t.string   "birth_city",             limit: 255
    t.string   "encrypted_password",     limit: 255
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 11,  default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token",   limit: 255
    t.string   "remember_token",         limit: 255
    t.datetime "reset_password_sent_at"
  end

  add_index "users", ["confirmation_token"], name: "users_index_users_on_confirmation_token"
  add_index "users", ["confirmed"], name: "users_index_users_on_confirmed"
  add_index "users", ["created_at"], name: "users_index_users_on_created_at"
  add_index "users", ["email"], name: "users_index_users_on_email"
  add_index "users", ["id"], name: "sqlite_autoindex_users_1", unique: true
  add_index "users", ["reset_password_token"], name: "users_index_users_on_reset_password_token"

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  limit: 255, null: false
    t.integer  "item_id",    limit: 11,  null: false
    t.string   "event",      limit: 255, null: false
    t.integer  "whodunnit",  limit: 11
    t.text     "object"
    t.datetime "created_at"
    t.string   "locale"
  end

  add_index "versions", ["id"], name: "sqlite_autoindex_versions_1", unique: true
  add_index "versions", ["item_type", "item_id"], name: "versions_index_versions_on_item_type_and_item_id"

end
