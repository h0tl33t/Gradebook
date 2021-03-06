ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'factory_girl'

class ActiveSupport::TestCase
  include SessionsHelper
  include SemestersHelper
  
  ActiveRecord::Migration.check_pending!
  
  #The following data is automatically generated when test_helper is loaded.
  dg = DataGenerator::Core.new
  dg.user(type: Admin) #Generate admin user.
  semesters = dg.semester(quantity: 2) #Generate two semesters, first of which will be current.
  teachers = dg.user(type: Teacher, quantity: 4) #Generate 4 teachers.
  students = dg.user(type: Student, quantity: 10) #Generate 10 students.
  courses = dg.course(semesters: semesters, teachers: teachers) #Generate semesters.size * teacher.size => 8 courses.
  enrollments = dg.enrollment(courses: courses, students: students) #Generate courses.size * students.size => 80 enrollments. 
end
