class CoursesController < ApplicationController  
  
  before_action :set_course, only: [:show, :edit, :update, :destroy]
  before_action :set_semester, only: [:index]
  before_action :disallow_student, except: [:index]
  before_action :disallow_admin, except: [:index, :show]
  
  # GET /courses
  # GET /courses.json
  def index
    if current_user.student?
      @courses = Course.for_semester(current_semester) + Course.without_enrollments - Course.not_enrollable_for(current_user)
      #Enrollable courses (not yet enrolled in for student) for a given semester or courses newly created without enrollments (needed separate query to catch these.)
    elsif current_user.teacher?
      @courses = Course.for_semester(current_semester).where(teacher: current_user).includes(:enrolled_students) #Courses taught for teacher in given semester.
    else
      @courses = Course.for_semester(current_semester) #All courses for a given semester.
    end
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    if current_user.teacher?
      @course = Course.includes(enrollments: :student).find(params[:id]) #Pull courses with student info and enrollments to list students w/ grades.
    elsif current_user.student?
      @course = Course.includes(:teacher, :enrollments).find(params[:id]) #Pull courses with teacher and enrollments to display teacher info and grades.
    else
      @course = Course.includes(:teacher, enrollments: :student).find(params[:id]) #Pull courses with teacher to display teacher info.
    end
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(course_params)
    
    respond_to do |format|
      if @course.save
        format.html { redirect_to semester_course_path(current_semester, @course), notice: 'Course was successfully created.' }
        format.json { render action: 'show', status: :created, location: @course }
      else
        format.html { render action: 'new' }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to semester_course_path(current_semester, @course), notice: 'Course was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy
    respond_to do |format|
      format.html { redirect_to semester_courses_path(current_semester) }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_course
    @course = Course.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
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
