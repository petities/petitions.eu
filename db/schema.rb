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

ActiveRecord::Schema.define(version: 20160107035649) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body",          limit: 65535
    t.string   "resource_id",   limit: 255,   null: false
    t.string   "resource_type", limit: 255,   null: false
    t.integer  "author_id",     limit: 4
    t.string   "author_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_comments", force: :cascade do |t|
    t.integer  "commentable_id",   limit: 4
    t.string   "commentable_type", limit: 255
    t.integer  "author_id",        limit: 4
    t.text     "body",             limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "allowed_cities", force: :cascade do |t|
    t.integer  "petition_type_id", limit: 4
    t.integer  "city_id",          limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "allowed_cities", ["city_id"], name: "index_allowed_cities_on_city_id", using: :btree
  add_index "allowed_cities", ["petition_type_id"], name: "index_allowed_cities_on_petition_type_id", using: :btree

  create_table "cities", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.datetime "imported_at"
    t.string   "imported_from", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0
    t.integer  "attempts",   limit: 4,     default: 0
    t.text     "handler",    limit: 65535
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "faq_translations", force: :cascade do |t|
    t.integer  "faq_id",     limit: 4,     null: false
    t.string   "locale",     limit: 255,   null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "question",   limit: 255
    t.text     "answer",     limit: 65535
  end

  add_index "faq_translations", ["faq_id"], name: "index_faq_translations_on_faq_id", using: :btree
  add_index "faq_translations", ["locale"], name: "index_faq_translations_on_locale", using: :btree

  create_table "faqs", force: :cascade do |t|
    t.string   "question",    limit: 255
    t.text     "answer",      limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug", limit: 255
    t.string   "group",       limit: 255
  end

  add_index "faqs", ["cached_slug"], name: "index_faqs_on_cached_slug", using: :btree

  create_table "feedbacks", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "email",             limit: 255
    t.string   "subject",           limit: 255
    t.text     "message",           limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "feedbackable_id",   limit: 4
    t.string   "feedbackable_type", limit: 255
    t.string   "recipient_email",   limit: 255
  end

  add_index "feedbacks", ["created_at"], name: "index_feedbacks_on_created_at", using: :btree
  add_index "feedbacks", ["email"], name: "index_feedbacks_on_email", using: :btree
  add_index "feedbacks", ["name"], name: "index_feedbacks_on_name", using: :btree

  create_table "images", force: :cascade do |t|
    t.integer  "imageable_id",        limit: 4
    t.string   "imageable_type",      limit: 255
    t.string   "upload_file_name",    limit: 255
    t.string   "upload_content_type", limit: 255
    t.integer  "upload_file_size",    limit: 4
    t.datetime "upload_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "alt_label",           limit: 255
  end

  add_index "images", ["imageable_id"], name: "index_images_on_imageable_id", using: :btree
  add_index "images", ["imageable_type"], name: "index_images_on_imageable_type", using: :btree

  create_table "initiations", force: :cascade do |t|
    t.string   "email",       limit: 255
    t.string   "unique_key",  limit: 255
    t.string   "name",        limit: 255
    t.integer  "petition_id", limit: 4
    t.integer  "office_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "new_signatures", force: :cascade do |t|
    t.integer  "petition_id",                 limit: 4,   default: 0,     null: false
    t.string   "person_name",                 limit: 255
    t.string   "person_street",               limit: 255
    t.string   "person_street_number_suffix", limit: 255
    t.string   "person_street_number",        limit: 255
    t.string   "person_postalcode",           limit: 255
    t.string   "person_function",             limit: 255
    t.string   "person_email",                limit: 255
    t.boolean  "person_dutch_citizen"
    t.datetime "signed_at"
    t.datetime "confirmed_at"
    t.boolean  "confirmed",                               default: false, null: false
    t.string   "unique_key",                  limit: 255
    t.boolean  "special"
    t.string   "person_city",                 limit: 255
    t.boolean  "subscribe",                               default: false
    t.string   "person_birth_date",           limit: 255
    t.string   "person_birth_city",           limit: 255
    t.integer  "sort_order",                  limit: 4,   default: 0,     null: false
    t.string   "signature_remote_addr",       limit: 255
    t.string   "signature_remote_browser",    limit: 255
    t.string   "confirmation_remote_addr",    limit: 255
    t.string   "confirmation_remote_browser", limit: 255
    t.boolean  "more_information",                        default: false, null: false
    t.boolean  "visible",                                 default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "person_born_at"
    t.integer  "reminders_sent",              limit: 4
    t.datetime "last_reminder_sent_at"
    t.date     "unconverted_person_born_at"
    t.string   "person_country",              limit: 2
  end

  add_index "new_signatures", ["confirmed"], name: "confirmed", using: :btree
  add_index "new_signatures", ["confirmed_at"], name: "date_confirmed", using: :btree
  add_index "new_signatures", ["person_email"], name: "person_email", using: :btree
  add_index "new_signatures", ["person_function"], name: "person_function", using: :btree
  add_index "new_signatures", ["petition_id", "special"], name: "index_signatures_on_petiton_id_and_special", using: :btree
  add_index "new_signatures", ["petition_id"], name: "petition_id", using: :btree
  add_index "new_signatures", ["signed_at"], name: "index_signatures_on_signed_at", using: :btree
  add_index "new_signatures", ["sort_order"], name: "sort_order", using: :btree
  add_index "new_signatures", ["special"], name: "index_signatures_on_special", using: :btree
  add_index "new_signatures", ["subscribe"], name: "subscribe", using: :btree
  add_index "new_signatures", ["unique_key"], name: "unique_key", using: :btree

  create_table "newsitems", force: :cascade do |t|
    t.string   "title",            limit: 255
    t.string   "title_clean",      limit: 255
    t.text     "text",             limit: 4294967295
    t.integer  "petition_id",      limit: 4
    t.integer  "office_id",        limit: 4
    t.string   "url",              limit: 255
    t.string   "url_text",         limit: 255
    t.string   "private_key",      limit: 255
    t.date     "date"
    t.date     "date_from"
    t.date     "date_until"
    t.boolean  "show_on_office"
    t.boolean  "show_on_home"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug",      limit: 255
    t.boolean  "show_on_petition"
  end

  add_index "newsitems", ["cached_slug"], name: "index_newsitems_on_cached_slug", using: :btree
  add_index "newsitems", ["date_from"], name: "index_newsitems_on_date_from", using: :btree
  add_index "newsitems", ["date_until"], name: "index_newsitems_on_date_until", using: :btree
  add_index "newsitems", ["office_id"], name: "index_newsitems_on_office_id", using: :btree
  add_index "newsitems", ["petition_id"], name: "index_newsitems_on_petition_id", using: :btree

  create_table "newsletters", force: :cascade do |t|
    t.integer  "petition_id",                limit: 4
    t.integer  "number",                     limit: 4
    t.string   "status",                     limit: 255
    t.boolean  "published",                                default: false, null: false
    t.datetime "publish_from"
    t.boolean  "creating_messages",                        default: false, null: false
    t.boolean  "messages_created",                         default: false, null: false
    t.datetime "messages_created_at"
    t.integer  "number_of_messages_created", limit: 4
    t.text     "text",                       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by",                 limit: 4
    t.integer  "approved_by",                limit: 4
    t.date     "date"
  end

  add_index "newsletters", ["petition_id"], name: "index_newsletters_on_petition_id", using: :btree
  add_index "newsletters", ["publish_from"], name: "index_newsletters_on_publish_from", using: :btree
  add_index "newsletters", ["published"], name: "index_newsletters_on_published", using: :btree
  add_index "newsletters", ["status"], name: "index_newsletters_on_status", using: :btree

  create_table "offices", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "name_clean",        limit: 255
    t.text     "text",              limit: 65535
    t.string   "url",               limit: 255
    t.boolean  "hidden"
    t.string   "postalcode",        limit: 255
    t.string   "email",             limit: 255
    t.integer  "organisation_id",   limit: 4
    t.string   "organisation_kind", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug",       limit: 255
    t.string   "subdomain",         limit: 255
    t.string   "url_text",          limit: 255
    t.string   "telephone",         limit: 255
    t.integer  "petition_type_id",  limit: 4
  end

  add_index "offices", ["cached_slug"], name: "index_offices_on_cached_slug", using: :btree
  add_index "offices", ["hidden"], name: "hidden", using: :btree
  add_index "offices", ["name_clean"], name: "name_clean", using: :btree
  add_index "offices", ["subdomain"], name: "index_offices_on_subdomain", using: :btree

  create_table "organisations", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "kind",       limit: 255
    t.string   "code",       limit: 5
    t.string   "region",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "visible"
  end

  add_index "organisations", ["kind"], name: "type", using: :btree
  add_index "organisations", ["name"], name: "name", using: :btree
  add_index "organisations", ["visible"], name: "index_organisations_on_visible", using: :btree

  create_table "pages", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.text     "content",     limit: 65535
    t.string   "cached_slug", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["cached_slug"], name: "index_pages_on_cached_slug", using: :btree

  create_table "petition_translations", force: :cascade do |t|
    t.integer  "petition_id", limit: 4,     null: false
    t.string   "locale",      limit: 255,   null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.text     "initiators",  limit: 65535
    t.text     "statement",   limit: 65535
    t.text     "request",     limit: 65535
    t.string   "slug",        limit: 255
  end

  add_index "petition_translations", ["locale"], name: "index_petition_translations_on_locale", using: :btree
  add_index "petition_translations", ["petition_id"], name: "index_petition_translations_on_petition_id", using: :btree

  create_table "petition_types", force: :cascade do |t|
    t.string   "name",                                        limit: 255
    t.text     "description",                                 limit: 65535
    t.integer  "required_minimum_age",                        limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "display_person_born_at"
    t.boolean  "display_person_birth_city"
    t.boolean  "require_person_born_at"
    t.boolean  "require_person_birth_city"
    t.boolean  "display_signature_person_citizen"
    t.boolean  "display_signature_full_address"
    t.boolean  "require_signature_full_address"
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
    t.boolean  "country_code"
  end

  create_table "petitions", force: :cascade do |t|
    t.string   "name",                             limit: 255
    t.string   "name_clean",                       limit: 255
    t.string   "subdomain",                        limit: 255
    t.text     "description",                      limit: 65535
    t.text     "initiators",                       limit: 65535
    t.text     "statement",                        limit: 65535
    t.text     "request",                          limit: 65535
    t.date     "date_projected"
    t.integer  "office_id",                        limit: 4
    t.integer  "organisation_id",                  limit: 4
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
    t.integer  "signatures_count",                 limit: 4,     default: 0,     null: false
    t.integer  "number_of_signatures_on_paper",    limit: 4,     default: 0,     null: false
    t.integer  "number_of_newsletters_sent",       limit: 4,     default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug",                      limit: 255
    t.datetime "last_confirmed_at"
    t.string   "status",                           limit: 255
    t.integer  "manager_id",                       limit: 4
    t.boolean  "show_twitter"
    t.boolean  "show_history"
    t.boolean  "show_map"
    t.string   "twitter_query",                    limit: 255
    t.string   "lat_lng",                          limit: 255
    t.string   "lat_lng_sw",                       limit: 255
    t.string   "lat_lng_ne",                       limit: 255
    t.integer  "special_count",                    limit: 4,     default: 0,     null: false
    t.boolean  "display_more_information"
    t.boolean  "display_signature_person_citizen",               default: false
    t.boolean  "display_signature_full_address",                 default: false
    t.boolean  "archived",                                       default: false
    t.integer  "petition_type_id",                 limit: 4
    t.boolean  "display_person_born_at"
    t.boolean  "display_person_birth_city"
    t.boolean  "delta",                                          default: true,  null: false
    t.text     "locale_list",                      limit: 65535
    t.float    "active_rate_value",                limit: 24,    default: 0.0
    t.integer  "owner_id",                         limit: 4
    t.string   "owner_type",                       limit: 255
    t.string   "reference_field",                  limit: 255
    t.date     "answer_due_date"
    t.string   "slug",                             limit: 255
  end

  add_index "petitions", ["cached_slug"], name: "index_petitions_on_cached_slug", using: :btree
  add_index "petitions", ["date_projected"], name: "date_projected", using: :btree
  add_index "petitions", ["last_confirmed_at"], name: "index_petitions_on_last_confirmed_at", using: :btree
  add_index "petitions", ["lat_lng"], name: "index_petitions_on_lat_lng", using: :btree
  add_index "petitions", ["name"], name: "name_2", using: :btree
  add_index "petitions", ["name_clean"], name: "name_clean", using: :btree
  add_index "petitions", ["office_id"], name: "office_id", using: :btree
  add_index "petitions", ["petitioner_name"], name: "petitioner_name", using: :btree
  add_index "petitions", ["status"], name: "index_petitions_on_status", using: :btree

  create_table "pledges", force: :cascade do |t|
    t.string   "influence",    limit: 255
    t.string   "skill",        limit: 255
    t.integer  "money",        limit: 4,   default: 0
    t.string   "feedback",     limit: 255
    t.boolean  "inform_me"
    t.integer  "petition_id",  limit: 4
    t.integer  "signature_id", limit: 4
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "pledges", ["petition_id", "signature_id"], name: "index_pledges_on_petition_id_and_signature_id", unique: true, using: :btree
  add_index "pledges", ["petition_id"], name: "index_pledges_on_petition_id", using: :btree
  add_index "pledges", ["signature_id"], name: "index_pledges_on_signature_id", using: :btree

  create_table "progressions", force: :cascade do |t|
    t.integer  "petition_id",         limit: 4
    t.text     "comment",             limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",              limit: 255
    t.integer  "user_id",             limit: 4
    t.boolean  "send_update_message",               default: true
    t.text     "public_comment",      limit: 65535
  end

  add_index "progressions", ["petition_id"], name: "petition_id", using: :btree
  add_index "progressions", ["status"], name: "index_progressions_on_status", using: :btree
  add_index "progressions", ["updated_at"], name: "index_progressions_on_updated_at", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "authorizable_type", limit: 255
    t.integer  "authorizable_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "resource_type",     limit: 255
    t.integer  "resource_id",       limit: 4
  end

  add_index "roles", ["authorizable_id"], name: "index_roles_on_authorizable_id", using: :btree
  add_index "roles", ["authorizable_type"], name: "index_roles_on_authorizable_type", using: :btree
  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "role_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "signatures", force: :cascade do |t|
    t.integer  "petition_id",                 limit: 4,   default: 0,     null: false
    t.string   "person_name",                 limit: 255
    t.string   "person_street",               limit: 255
    t.string   "person_street_number_suffix", limit: 255
    t.string   "person_street_number",        limit: 255
    t.string   "person_postalcode",           limit: 255
    t.string   "person_function",             limit: 255
    t.string   "person_email",                limit: 255
    t.boolean  "person_dutch_citizen"
    t.datetime "signed_at"
    t.datetime "confirmed_at"
    t.boolean  "confirmed",                               default: false, null: false
    t.string   "unique_key",                  limit: 255
    t.boolean  "special"
    t.string   "person_city",                 limit: 255
    t.boolean  "subscribe",                               default: false
    t.string   "person_birth_date",           limit: 255
    t.string   "person_birth_city",           limit: 255
    t.integer  "sort_order",                  limit: 4,   default: 0,     null: false
    t.string   "signature_remote_addr",       limit: 255
    t.string   "signature_remote_browser",    limit: 255
    t.string   "confirmation_remote_addr",    limit: 255
    t.string   "confirmation_remote_browser", limit: 255
    t.boolean  "more_information",                        default: false, null: false
    t.boolean  "visible",                                 default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "person_born_at"
    t.integer  "reminders_sent",              limit: 4
    t.datetime "last_reminder_sent_at"
    t.date     "unconverted_person_born_at"
    t.string   "person_birth_country",        limit: 2
    t.string   "person_country",              limit: 2
  end

  add_index "signatures", ["confirmed"], name: "confirmed", using: :btree
  add_index "signatures", ["confirmed_at"], name: "date_confirmed", using: :btree
  add_index "signatures", ["person_email"], name: "person_email", using: :btree
  add_index "signatures", ["person_function"], name: "person_function", using: :btree
  add_index "signatures", ["petition_id", "special"], name: "index_signatures_on_petiton_id_and_special", using: :btree
  add_index "signatures", ["petition_id"], name: "petition_id", using: :btree
  add_index "signatures", ["signed_at"], name: "index_signatures_on_signed_at", using: :btree
  add_index "signatures", ["sort_order"], name: "sort_order", using: :btree
  add_index "signatures", ["special"], name: "index_signatures_on_special", using: :btree
  add_index "signatures", ["subscribe"], name: "subscribe", using: :btree
  add_index "signatures", ["unique_key"], name: "unique_key", using: :btree

  create_table "signatures_reconfirmations", force: :cascade do |t|
    t.integer  "signature_id",               limit: 4
    t.string   "phase",                      limit: 255
    t.string   "status",                     limit: 255
    t.string   "unique_key",                 limit: 255, null: false
    t.datetime "message_sent_at"
    t.boolean  "reconfirmed"
    t.datetime "reconfirmed_at"
    t.string   "reconfirmed_remote_addr",    limit: 255
    t.string   "reconfirmed_remote_browser", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "signatures_reconfirmations", ["reconfirmed"], name: "index_signatures_reconfirmations_on_reconfirmed", using: :btree
  add_index "signatures_reconfirmations", ["signature_id"], name: "index_signatures_reconfirmations_on_signature_id", using: :btree
  add_index "signatures_reconfirmations", ["status"], name: "index_signatures_reconfirmations_on_status", using: :btree
  add_index "signatures_reconfirmations", ["unique_key"], name: "index_signatures_reconfirmations_on_unique_key", unique: true, using: :btree

  create_table "slugs", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.integer  "sluggable_id",   limit: 4
    t.integer  "sequence",       limit: 4,   default: 1, null: false
    t.string   "sluggable_type", limit: 40
    t.string   "scope",          limit: 40
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence"], name: "index_slugs_on_n_s_s_and_s", unique: true, using: :btree
  add_index "slugs", ["sluggable_id"], name: "index_slugs_on_sluggable_id", using: :btree

  create_table "statistics", force: :cascade do |t|
    t.integer  "statisticable_id",   limit: 4
    t.string   "statisticable_type", limit: 255
    t.string   "kind",               limit: 255
    t.string   "reporting_period",   limit: 255
    t.datetime "start_at"
    t.integer  "value",              limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        limit: 4
    t.integer  "taggable_id",   limit: 4
    t.integer  "tagger_id",     limit: 4
    t.string   "tagger_type",   limit: 40
    t.string   "taggable_type", limit: 40
    t.string   "context",       limit: 255
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "task_statuses", force: :cascade do |t|
    t.string   "task_name",   limit: 255
    t.integer  "petition_id", limit: 4
    t.string   "message",     limit: 255
    t.integer  "count",       limit: 4
    t.datetime "last_action"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tolk_locales", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tolk_locales", ["name"], name: "index_tolk_locales_on_name", unique: true, using: :btree

  create_table "tolk_phrases", force: :cascade do |t|
    t.text     "key",        limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tolk_translations", force: :cascade do |t|
    t.integer  "phrase_id",       limit: 4
    t.integer  "locale_id",       limit: 4
    t.text     "text",            limit: 65535
    t.text     "previous_text",   limit: 65535
    t.boolean  "primary_updated",               default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tolk_translations", ["phrase_id", "locale_id"], name: "index_tolk_translations_on_phrase_id_and_locale_id", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",               limit: 255
    t.string   "name",                   limit: 255
    t.string   "email",                  limit: 255
    t.boolean  "confirmed",                          default: false, null: false
    t.string   "crypted_password",       limit: 255
    t.string   "password_salt",          limit: 255
    t.string   "persistence_token",      limit: 255
    t.string   "single_access_token",    limit: 255
    t.string   "perishable_token",       limit: 255
    t.integer  "login_count",            limit: 4,   default: 0,     null: false
    t.integer  "failed_login_count",     limit: 4,   default: 0,     null: false
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
    t.datetime "reset_password_sent_at"
    t.string   "encrypted_password",     limit: 255
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token",   limit: 255
    t.string   "remember_token",         limit: 255
    t.string   "unconfirmed_email",      limit: 255
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["confirmed"], name: "index_users_on_confirmed", using: :btree
  add_index "users", ["created_at"], name: "index_users_on_created_at", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "role_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  limit: 255,   null: false
    t.integer  "item_id",    limit: 4,     null: false
    t.string   "event",      limit: 255,   null: false
    t.integer  "whodunnit",  limit: 4
    t.text     "object",     limit: 65535
    t.datetime "created_at"
    t.string   "locale",     limit: 255
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
