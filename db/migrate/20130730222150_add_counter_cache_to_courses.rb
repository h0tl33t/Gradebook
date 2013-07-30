class AddCounterCacheToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :enrollments_count, :integer, default: 0
    
    Course.reset_column_information
    Course.pluck(:id) do |c_id|
      Course.reset_counters c_id, :enrollments
    end
  end
end
