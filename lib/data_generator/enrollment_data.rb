module DataGenerator
  class EnrollmentData
    attr_accessor :enrollments
  
    def initialize(options = {})
      student_ids = options[:students]
      @course_ids = options[:courses]
      @grade = options[:grade]
      @per_student = options[:courses_per_student] || @course_ids.size
      @random = Random.new
    
      @enrollments = []
      student_ids.each {|student_id| @enrollments << generate_enrollments_for(student_id)}
      @enrollments.flatten!
    end
  
    def generate_enrollments_for(student_id)
      enrollments = @course_ids.sample(@per_student).inject([]) do |collection, course_id|
        collection << {student_id: student_id, course_id: course_id, grade: @grade || generate_grade}
        collection
      end
    end
  
    def generate_grade
      GradeHelper.nearest_decimal_grade(@random.rand(0.0..4.0).round(1))
    end
  end
end