module DataGenerator
  class Core
  
    def initialize
      @random = Random.new
    end
  
    def user(options = {}) #Creates users and returns created users in a results array.
      options[:type] ||= Student #Default to Student.
      attr_hashes = DataGenerator::UserData.new(options).users
      create_with(options[:type], attr_hashes)
    end
  
    def semester(options = {}) #Creates semesters and returns created semesters in a results array.
      attr_hashes = DataGenerator::SemesterData.new(options).semesters
      create_with(Semester, attr_hashes)
    end
  
    def course(options = {}) #Creates courses and returns created courses in a results array.
      options[:semesters] ||= semester.map(&:id) #Feed ids.
      options[:teachers] ||= user(type: Teacher).map(&:id) #Feed ids.
      attr_hashes = DataGenerator::CourseData.new(options).courses
      create_with(Course, attr_hashes)
    end
  
    def enrollment(options = {})
      options[:students] ||= user.map(&:id) #Feed ids.
      options[:courses] ||= course.map(&:id) #Feed ids.
      attr_hashes = DataGenerator::EnrollmentData.new(options).enrollments
      create_with(Enrollment, attr_hashes)
    end
  
    def all
      teachers = user(type: Teacher, quantity: 50)
      students = user(type: Student, quantity: 200)
      semesters = semester(quantity: 8)
      courses = course(quantity: 200, semesters: semesters.map(&:id), teachers: teachers.map(&:id))
      enrollment(students: students.map(&:id), courses: courses.map(&:id), courses_per_student: 40)
    end
  
    private
    def create_with(klass, attr_hashes)
      results = attr_hashes.inject([]) do |objects, attrs|
        objects << klass.create(attrs)
        objects
      end
    end
  end
end