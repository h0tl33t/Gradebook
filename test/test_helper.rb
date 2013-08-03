ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'factory_girl'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
  
  #Generation gets automatically run when tests are loaded.
  dg = DataGenerator::Core.new
  dg.user(type: Admin) #Generate admin user.
  semesters = dg.semester(quantity: 2) #Generate two semesters, first of which will be current.
  teachers = dg.user(type: Teacher, quantity: 4) #Generate 4 teachers.
  students = dg.user(type: Student, quantity: 10) #Generate 10 students.
  courses = dg.course(semesters: semesters, teachers: teachers) #Generate semesters.size * teacher.size => 8 courses.
  enrollments = dg.enrollment(courses: courses, students: students) #Generate courses.size * students.size => 80 enrollments. 
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
end
