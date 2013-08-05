module DataGenerator
  class SemesterData
    attr_accessor :semesters
  
    def initialize(options = {})
      @quantity = options[:quantity] || 1
      @days_long = options[:days_long] || 90
    
      @occupied_date_ranges = Semester.order(:start_date).select(:start_date, :end_date).map {|semester| (semester.start_date..semester.end_date)}
      @future = true #Use to swap back and forth, adding a semester in front and then behind, ensuring there's an equal distribution of past and future semesters.   
    
      @semesters = []
      @quantity.times {@semesters << generate_semester_data_hash}
    end
  
    def generate_semester_data_hash 
      start_date, end_date = generate_start_and_end_dates
      name = generate_semester_name(start_date)
      {name: name, start_date: start_date, end_date: end_date}
    end
    
    def determine_start_date_for_current_semester
      case Date.today.month
      when (6..8) #If today is between the months of June and August, set June 1.
        Date.parse("01-06-#{Date.today.year}")
      when (9..11) #if today is between the months of September and November, set September 1.
        Date.parse("01-09-#{Date.today.year}")
      when (12) #If today is in December, set December 1.
        Date.parse("01-12-#{Date.today.year}")
      when (1..2) #If today is between January and February, set December 1 for the prior year.
        yr = (Date.today - 1.year).year
        Date.parse("01-12-#{yr}")
      when (3..5) #If today is between March and May, set March 1.
        Date.parse("01-03-#{Date.today.year}")
      end
    end
  
    def generate_start_and_end_dates
      start_date, end_date = nil, nil
    
      if @occupied_date_ranges.empty? #No semesters created yet.
        start_date = determine_start_date_for_current_semester
        end_date = start_date + @days_long.days
      elsif @future #Current semester already set, tack a new semester on to the end of last semester tracked.
        start_date = @occupied_date_ranges.last.last + 1.day
        end_date = start_date + @days_long.days
        @future = false #Swap so next semester is created for the past.
      else#Current semester already set, tack a new semester before all other tracked semesters.
        end_date = @occupied_date_ranges.first.first - 1.day
        start_date = end_date - @days_long.days
        @future = true #Swap so next semester is created for the future.
      end
    
      track_date_range((start_date..end_date)) #Add new date range to tracked date ranges.
      return start_date, end_date #Return start and end dates.
    end
  
    def generate_semester_name(start_date)
      "#{season_for(start_date)} #{start_date.year}"
    end
  
    def track_date_range(range)
      @occupied_date_ranges << range
      @occupied_date_ranges.sort_by! {|range| range.first} #Sorts ranges in ascending order.
    end
  
    def season_for(start_date)
      mid_point_month = (start_date + (@days_long/2).days).month
      case mid_point_month
      when (3..5)
        'Spring'
      when (6..8)
        'Summer'
      when (9..11)
        'Fall'
      else
        'Winter'
      end
    end
  end
end