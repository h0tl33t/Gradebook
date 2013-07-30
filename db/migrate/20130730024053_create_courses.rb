class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.string :long_title
      t.string :description
      t.float :credit_hours

      t.timestamps
    end
  end
end
