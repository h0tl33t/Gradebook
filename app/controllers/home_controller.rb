class HomeController < ApplicationController
  def index
    current_courses = Course.where(semester: current_semester)
    @year = Semester.order(:start_date).first.start_date.year
    @active_students = Enrollment.where(course_id: current_courses).select(:student_id).distinct.count
    @awesome_courses = current_courses.sample(3)
  end
end
