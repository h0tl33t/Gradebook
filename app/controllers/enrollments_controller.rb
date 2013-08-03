class EnrollmentsController < ApplicationController
  include SessionsHelper
  
  before_action :set_enrollment, only: [:show, :edit, :update, :destroy]
  before_action :set_semester, only: [:index]
  before_action :allow_student, only: [:index]
  
  # GET /enrollments
  # GET /enrollments.json
  def index
    @enrollments = current_user.enrollments.with_courses_for_semester(current_semester)
    @total_credit_hours = @enrollments.inject(0) {|total, enrollment| total += enrollment.course.credit_hours}
  end

  # GET /enrollments/1
  # GET /enrollments/1.json
  def show
  end

  # GET /enrollments/new
  def new
    @enrollment = Enrollment.new
  end

  # GET /enrollments/1/edit
  def edit
  end

  # POST /enrollments
  # POST /enrollments.json
  def create
    format_letter_grades
    @enrollment = Enrollment.new(enrollment_params)
    respond_to do |format|
      if @enrollment.save
        format.html { redirect_to course_path(@enrollment.course), notice: 'Enrollment was successfully created.'}
        format.json { render action: 'show', status: :created, location: @enrollment }
      else
        format.html { render action: 'new' }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /enrollments/1
  # PATCH/PUT /enrollments/1.json
  def update
    format_letter_grades
    #params[:enrollment][:grade] = GradeHelper.numeric_grade_for(params[:enrollment][:grade])
    respond_to do |format|
      if @enrollment.update(enrollment_params)
        format.html { redirect_to course_path(@enrollment.course), notice: 'Enrollment was successfully updated.'}
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /enrollments/1
  # DELETE /enrollments/1.json
  def destroy
    @enrollment.destroy
    respond_to do |format|
      format.html { redirect_to enrollments_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_enrollment
      @enrollment = Enrollment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def enrollment_params
      params.require(:enrollment).permit(:student_id, :course_id, :grade, :semester_id)
    end
    
    def format_letter_grades
      params[:enrollment][:grade] = GradeHelper.numeric_grade_for(params[:enrollment][:grade])
    end
    
    def allow_student
      redirect_to courses_path unless current_user.student?
    end
    
    def set_semester
      if params[:enrollment] && params[:enrollment][:semester_id]
        self.current_semester = Semester.find(params[:enrollment][:semester_id])
        params[:semester_id] = current_semester
      elsif params[:semester_id]
        self.current_semester = Semester.find(params[:semester_id])
      else
        self.current_semester = Semester.current
      end
    end
end
