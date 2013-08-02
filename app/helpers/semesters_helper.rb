module SemestersHelper
  def current_semester
    @semester ||= Semester.current
  end
  
  def current_semester=(semester)
    @semester = semester
  end
end
