class CreateEnrollments < ActiveRecord::Migration
  def change
    create_table :enrollments do |t|
      t.integer :student_id
      t.index :student_id
      t.integer :course_id
      t.index :course_id
      t.float :grade

      t.timestamps
    end
  end
end
