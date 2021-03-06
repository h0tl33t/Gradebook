module DataGenerator
  class Core
  
    def initialize
      @random = Random.new
    end
  
    def user(options = {}) #Creates users and returns created users in a results array.
      options[:type] ||= Student #Default to Student.
      attr_hashes = DataGenerator::UserData.new(options).users
      results = create_with(options[:type], attr_hashes, options[:action])
      results.size > 1 ? results : results.first
    end
  
    def semester(options = {}) #Creates semesters and returns created semesters in a results array.
      attr_hashes = DataGenerator::SemesterData.new(options).semesters
      results = create_with(Semester, attr_hashes, options[:action])
      results.size > 1 ? results : results.first
    end
  
    def course(options = {}) #Creates courses and returns created courses in a results array.
      options[:semesters] ? options[:semesters] = grab_ids_from(options[:semesters]) : options[:semesters] = grab_ids_from(semester) #Feed ids.
      options[:teachers] ? options[:teachers] = grab_ids_from(options[:teachers]) : options[:teachers] = grab_ids_from(user(type: Teacher)) #Feed ids.
      attr_hashes = DataGenerator::CourseData.new(options).courses
      results = create_with(Course, attr_hashes, options[:action])
      results.size > 1 ? results : results.first
    end
  
    def enrollment(options = {})
      options[:students] ? options[:students] = grab_ids_from(options[:students]) : options[:students] = grab_ids_from(user(type: Student)) #Feed ids.
      options[:courses] ? options[:courses] = grab_ids_from(options[:courses]) : options[:courses] = grab_ids_from(course) #Feed ids.
      attr_hashes = DataGenerator::EnrollmentData.new(options).enrollments
      results = create_with(Enrollment, attr_hashes, options[:action])
      results.size > 1 ? results : results.first
    end
  
    def all
      teachers = user(type: Teacher, quantity: 10)
      students = user(type: Student, quantity: 150)
      semesters = semester(quantity: 6)
      courses = course(semesters: semesters, teachers: teachers) #Should generate number_of_teachers * number_of_semesters * 2 courses. (120 by default)
      enrollment(students: students, courses: courses, courses_per_student: 30) #Should come out to approximately 5 enrollments per semester.
    end
  
    private
    def create_with(klass, attr_hashes, action)
      action ||= :create
      results = attr_hashes.inject([]) do |objects, attrs|
        objects << klass.send(action, attrs)
        objects
      end
    end

    def grab_ids_from(obj)
      if is_id?(obj)
        [obj]
      elsif is_model?(obj)
        [obj.id]
      elsif are_ids?(obj)
        obj
      elsif are_models?(obj)
        obj.map(&:id)
      elsif are_proxies?(obj)
        obj.to_a.map(&:id)
      else
        nil
      end
    end
    
    def is_id?(obj)
      obj.class == Integer
    end
    
    def is_model?(obj)
      obj.class.method_defined?(:id)
    end
    
    def are_ids?(obj)
      obj.class == Array and is_id?(obj.first)
    end
    
    def are_models?(obj)
      obj.class == Array and is_model?(obj.first)
    end
    
    def are_proxies?(obj)
      obj.class.to_s.include?('ActiveRecord::Relation') or obj.class.to_s.include?('ActiveRecord::Associations::CollectionProxy') 
    end
  end
end