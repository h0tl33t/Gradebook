class AddTeacherIdToCourses < ActiveRecord::Migration
  def change
    add_reference :courses, :teacher, index: true
  end
end
