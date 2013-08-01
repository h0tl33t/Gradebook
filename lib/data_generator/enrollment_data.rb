module DataGenerator
  class EnrollmentData
    attr_accessor :enrollments
  
    def initialize(options = {})
      students = options[:students]
      @courses = options[:courses]
      @per_student = options[:courses_per_student] || @courses.size
      @random = Random.new
    
      @enrollments = []
      students.each {|student| @enrollments << generate_enrollments_for(student)}
      @enrollments.flatten!
    end
  
    def generate_enrollments_for(student)
      enrollments = @courses.sample(@per_student).inject([]) do |collection, course|
        collection << {student_id: student, course_id: course, grade: generate_grade}
        collection
      end
    end
  
    def generate_grade
      @random.rand(0.0..4.0).round(1)
    end
  end
end