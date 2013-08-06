class EnrollmentsController < ApplicationController
  include SemestersHelper
  
  before_action :set_enrollment, only: [:update, :destroy]
  before_action :set_semester, only: [:index]
  before_action :disallow_admin
  before_action :disallow_student, except: [:index, :create, :destroy]
  before_action :disallow_teacher, except: [:update]
  
  def index
    @enrollments = current_user.enrollments_for(current_semester)
    @total_credit_hours = @enrollments.inject(0) {|total, enrollment| total += enrollment.course.credit_hours}
  end

  def create
    format_letter_grades #Format letter grade if received in params.
    params[:enrollment][:grade] = GradeHelper.random_grade #Assign random grade for new enrollments (purely to showcase GPA/grade related functionality).
    @enrollment = Enrollment.new(enrollment_params)
    if @enrollment.save
      redirect_to semester_enrollments_path(params[:semester_id]), notice: "Successfully enrolled in #{@enrollment.course.name}."
    else
      flash.now[:error] = 'Enrollment was unsuccessful.'
      redirect_to semester_courses_path(current_semester)
    end
  end

  def update
    format_letter_grades
    if @enrollment.update(enrollment_params)
      redirect_to semester_course_path(params[:semester_id], @enrollment.course), notice: "Successfully updated #{@enrollment.student.full_name}'s grade to #{GradeHelper.letter_grade_for(@enrollment.grade)}."
    else
      render action: 'edit'
    end
  end

  def destroy
    @enrollment.destroy
    redirect_to semester_enrollments_path, notice: "Unenrolled from #{@enrollment.course.name}."
  end

  private
    def set_enrollment
      @enrollment = Enrollment.find(params[:id])
    end
    
    def enrollment_params
      params.require(:enrollment).permit(:student_id, :course_id, :grade, :semester_id)
    end
    
    def format_letter_grades
      params[:enrollment][:grade] = GradeHelper.numeric_grade_for(params[:enrollment][:grade])
    end
    
    def disallow_student
      redirect_to semester_courses_path(current_semester) if current_user.student?
    end
    
    def disallow_teacher
      redirect_to semester_courses_path(current_semester) if current_user.teacher?
    end
    
    def disallow_admin
      redirect_to semester_courses_path(current_semester) if current_user.admin?
    end
end
