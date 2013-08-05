module SemestersHelper
  def current_semester
    @current_semester ||= Semester.current
  end
  
  def current_semester=(semester)
    @current_semester = semester
  end
  
  def all_semesters
    @all_semesters ||= Semester.order(:start_date)
  end
  
  def actionable_semesters
    @actionable_semesters ||= Semester.where('end_date >= ?', Date.today)
  end
  
  def set_semester
    if params[:semester] && params[:semester][:id] #Catch new semester if one is picked from form_for :semester collection_select :id.
      self.current_semester = Semester.find(params[:semester][:id])
    elsif params[:semester_id] #If not, grab semester from resource route.
      self.current_semester = Semester.find(params[:semester_id])
    else
      self.current_semester = Semester.current #If no semester ids are in params, return the current_semester.
    end
  end
end
