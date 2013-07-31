class AddAverageGradeToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :average_grade, :float, default: 0.0
  end
end
