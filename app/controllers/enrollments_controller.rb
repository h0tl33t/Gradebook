class EnrollmentsController < ApplicationController
  before_action :set_enrollment, only: [:show, :edit, :update, :destroy]
  before_action :set_semester, only: [:index]
  before_action :disallow_admin
  before_action :disallow_student, except: [:index, :create, :destroy]
  before_action :disallow_teacher, except: [:update]
  
  # GET /enrollments
  # GET /enrollments.json
  def index
    @enrollments = current_user.enrollments_for(current_semester)
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
    format_letter_grades #Format letter grade if received in params.
    params[:enrollment][:grade] = GradeHelper.random_grade #Assign random grade for new enrollments (purely to showcase GPA/grade related functionality).
    @enrollment = Enrollment.new(enrollment_params)
    respond_to do |format|
      if @enrollment.save
        format.html { redirect_to semester_enrollments_path(params[:semester_id]), notice: "Successfully enrolled in #{@enrollment.course.name}."}
        format.json { render action: 'show', status: :created, location: @enrollment }
      else
        format.html { 
            flash.now[:error] = 'Enrollment was unsuccessful.'
            redirect_to semester_courses_path(current_semester) }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /enrollments/1
  # PATCH/PUT /enrollments/1.json
  def update
    format_letter_grades
    respond_to do |format|
      if @enrollment.update(enrollment_params)
        format.html { redirect_to semester_course_path(current_semester, @enrollment.course), notice: 'Enrollment was successfully updated.'}
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
      format.html { redirect_to semester_enrollments_path, notice: "Unenrolled from #{@enrollment.course.name}."}
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
