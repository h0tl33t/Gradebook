class SemestersController < ApplicationController
  
  before_action :set_semester, only: [:edit, :update, :destroy]
  before_action :disallow_non_admin

  def index
    @semesters = Semester.order(:start_date)
  end

  def show
    redirect_to semesters_path
  end

  def new
    @semester = Semester.new
  end

  def edit
  end

  def create
    @semester = Semester.new(semester_params)
    if @semester.save
      redirect_to semesters_path, notice: 'Semester was successfully created.'
    else 
      render action: 'new'
    end
  end

  def update
    if @semester.update(semester_params)
      redirect_to semesters_path, notice: 'Semester was successfully updated.'
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @semester.destroy
    redirect_to semesters_path, notice: 'Semester and all its associated data has been deleted.'
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
