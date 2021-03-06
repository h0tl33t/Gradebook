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

ActiveRecord::Schema.define(version: 20130803011933) do

  create_table "courses", force: true do |t|
    t.string   "name"
    t.string   "long_title"
    t.string   "description"
    t.float    "credit_hours"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "semester_id"
    t.integer  "enrollments_count", default: 0
    t.integer  "teacher_id"
    t.float    "average_grade",     default: 0.0
  end

  add_index "courses", ["semester_id"], name: "index_courses_on_semester_id"
  add_index "courses", ["teacher_id"], name: "index_courses_on_teacher_id"

  create_table "enrollments", force: true do |t|
    t.integer  "student_id"
    t.integer  "course_id"
    t.float    "grade"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "enrollments", ["course_id"], name: "index_enrollments_on_course_id"
  add_index "enrollments", ["student_id"], name: "index_enrollments_on_student_id"

  create_table "semesters", force: true do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "courses_count", default: 0
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.string   "password_digest"
  end

end
