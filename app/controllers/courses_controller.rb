class CoursesController < ApplicationController  
  include SemestersHelper
  
  before_action :set_course, only: [:show, :edit, :update, :destroy]
  before_action :set_semester, only: [:index]
  before_action :disallow_student, except: [:index]
  before_action :disallow_admin, except: [:index, :show]
  
  def index
    if current_user.student?
      @courses = Course.for_semester(current_semester).enrollable - Course.for_semester(current_semester).not_enrollable_for(current_user)
      #Grab courses for a given semester and then remove the courses for which the current_user(student) is already enrolled in.
    elsif current_user.teacher?
      @courses = Course.for_semester(current_semester).where(teacher: current_user).includes(:enrolled_students) #Courses taught for teacher in given semester.
    else
      @courses = Course.for_semester(current_semester) #All courses for a given semester.
    end
  end

  def show
    if current_user.teacher?
      @course = Course.includes(enrollments: :student).find(params[:id]) #Pull courses with student info and enrollments to list students w/ grades.
    elsif current_user.student?
      @course = Course.includes(:teacher, :enrollments).find(params[:id]) #Pull courses with teacher and enrollments to display teacher info and grades.
    else
      @course = Course.includes(:teacher, enrollments: :student).find(params[:id]) #Pull courses with teacher to display teacher info.
    end
  end

  def new
    @course = Course.new
  end

  def edit
  end

  def create
    @course = Course.new(course_params)
    if @course.save
      redirect_to semester_course_path(current_semester, @course), notice: 'Course was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @course.update(course_params)
      redirect_to semester_course_path(current_semester, @course), notice: 'Course was successfully updated.'
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @course.destroy
    redirect_to semester_courses_path(current_semester)
  end

  private
    def set_course
      @course = Course.find(params[:id])
    end

    def course_params
      params.require(:course).permit(:name, :long_title, :description, :credit_hours, :semester_id, :teacher_id)
    end
    
    def disallow_admin
      redirect_to semester_courses_path(current_semester) if current_user.admin?
    end
  
    def disallow_student
      redirect_to semester_courses_path(current_semester) if current_user.student?
    end
end
