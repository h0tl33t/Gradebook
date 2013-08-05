class SemestersController < ApplicationController
  
  before_action :set_semester, only: [:edit, :update, :destroy]
  before_action :disallow_non_admin
  
  # GET /semesters
  # GET /semesters.json
  def index
    @semesters = Semester.order(:start_date)
  end

  # GET /semesters/1
  # GET /semesters/1.json
  def show
    redirect_to semesters_path
  end

  # GET /semesters/new
  def new
    @semester = Semester.new
  end

  # GET /semesters/1/edit
  def edit
  end

  # POST /semesters
  # POST /semesters.json
  def create
    @semester = Semester.new(semester_params)

    respond_to do |format|
      if @semester.save
        format.html { redirect_to semesters_path, notice: 'Semester was successfully created.' }
        format.json { render action: 'show', status: :created, location: semesters_path }
      else
        format.html { render action: 'new' }
        format.json { render json: @semester.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /semesters/1
  # PATCH/PUT /semesters/1.json
  def update
    respond_to do |format|
      if @semester.update(semester_params)
        format.html { redirect_to semesters_path, notice: 'Semester was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @semester.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /semesters/1
  # DELETE /semesters/1.json
  def destroy
    @semester.destroy
    respond_to do |format|
      format.html { redirect_to semesters_path, notice: 'Semester and all its associated data has been deleted.'}
      format.json { head :no_content }
    end
  end

  private
  def set_semester
    @semester = Semester.find(params[:id])
  end

  def semester_params
    params.require(:semester).permit(:name, :start_date, :end_date)
  end
    
  def disallow_non_admin
    redirect_to root_path unless current_user.admin?
  end
end
