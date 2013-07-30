class AddSemesterRefToCourses < ActiveRecord::Migration
  def change
    add_reference :courses, :semester, index: true
  end
end
