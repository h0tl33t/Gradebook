class AddCoursesCountToSemesters < ActiveRecord::Migration
  def change
    add_column :semesters, :courses_count, :integer, default: 0
    
    Semester.reset_column_information
    Semester.pluck(:id) do |s_id|
      Semester.reset_counters s_id, :courses
    end
  end
end
