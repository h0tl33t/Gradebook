class CourseData
  attr_accessor :courses  
    def initialize(options = {})
    @quantity = options[:quantity] || 1
    @semesters = options[:semesters]
    @teachers = options[:teachers]
    @random = Random.new
    
    @courses = []
    @quantity.times {@courses << generate_course_data_hash}
  end
  
  COURSE_TYPES = {'MATH' => 'Mathematics',
                  'SCI' => 'Science',
                  'CS' => 'Computer Science',
                  'IS' => 'Information Science',
                  'HIST' => 'History',
                  'ARCH' => 'Architecture',
                  'CHEM' => 'Chemistry',
                  'PHYS' => 'Physics',
                  'ART' => 'Art',
                  'MUSIC' => 'Music',
                  'PSYCH' => 'Psychology',
                  'SOC' => 'Sociology',
                  'EE' => 'Electrical Engineering',
                  'MECHE' => 'Mechinical Engineering',
                  'CALC' => 'Calculus',
                  'BIO' => 'Biology',
                  'FIN' => 'Finance',
                  'ACC' => 'Accounting',
                  'BUS' => 'Business'}

  def generate_course_data_hash
    base_name = COURSE_TYPES.keys.sample
    number = @random.rand(101..499)
    name, long_title = generate_course_names(base_name, number)
    credit_hours = generate_credit_hours
    description = generate_course_description(credit_hours)
    {name: name, long_title: long_title, credit_hours: credit_hours, description: description, semester_id: @semesters.sample, teacher_id: @semesters.sample}
  end

  def generate_course_names(base_name, number)
    name = [base_name, number].join(' ')
    title = [complexity_text_for(number), COURSE_TYPES[base_name]].join(' ')
    return name, title
  end

  def complexity_text_for(number)
    case number
    when (101..199)
      ['An Introduction to', 'A Foundation for', 'Understanding the Principles of'].sample
    when (200..299)
      ['Intermediate Concepts for', 'Diving Deeper with', 'A More Advanced Look at'].sample
    when (300..399)
      ['Understanding the Structures Behind', 'Themes Throughout the Development of', 'Exploring the Intracacies of'].sample
    when (400..499)
      ['Industry Case Studies in', 'Using Innovative Analytics in', 'Complex Theories in', 'Mastering'].sample
    end
  end

  def generate_course_description(credit_hours)
    case credit_hours
    when (0.5..1.5)
      "Times: M/W from #{time_slot_for(45)}.  Location: #{location}."
    when (2.0..2.5)
      ["Times: M/W/F from #{time_slot_for(45)}. Location: #{location}.","Times: T/R from #{time_slot_for(45)}. Location: #{location}."].sample
    when (3.0..3.5)
      ["Times: M/W/F from #{time_slot_for(60)}. Location: #{location}.","Times: T/R from #{time_slot_for(90)}. Location: #{location}."].sample
    when 4.0
      ["Times: M/W/F from #{time_slot_for(90)}. Location: #{location}.","Times: M-F from #{time_slot_for(60)}. Location: #{location}."].sample
    end
  end


  def time_slot_for(duration_in_minutes)
    hours_to_add = duration_in_minutes/60
    minutes_to_add = duration_in_minutes.modulo(60)

    start_hour = [8,9,10,11,12,1,2,3,4,5].sample #8AM to 5PM
    class_start = "#{start_hour}:00#{meridian_indicator(start_hour)}"

    end_hour = start_hour + hours_to_add
    class_end = "#{end_hour}:#{minutes_to_add.to_s.rjust(2,'0')}#{meridian_indicator(end_hour)}"

    "#{class_start} to #{class_end}"
  end

  def meridian_indicator(hour) #Assuming course schedule with valid class start hours between 8AM and 5PM.
    (8..12).cover?(hour) ? 'AM' : 'PM'
  end

  def location
    buildings = ['Boucke','Waterford','Smeel','Ford','Osmond','Mueller','Ritenour','Wartik','Sackett','Willard','Chambers','Buckhout','Fenskey','Walker']
    "#{@random.rand(1..399)} #{buildings.sample}"
  end

  def generate_credit_hours
    hours = [*0..4].sample + [0.0, 0.5].sample
    if hours == 0.0
      0.5
    elsif hours == 4.5
      4.0
    else
      hours
    end
  end
end