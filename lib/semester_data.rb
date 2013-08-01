class SemesterData
  attr_accessor :semesters
  
  def initialize(options = {})
    @quantity = options[:quantity] || 1 #Given default of 120 days, looking at 4 years worth of semesters by default.
    @days_long = options[:days_long] || 120
    
    @occupied_date_ranges = []
    @future = true #Use to swap back and forth, adding a semester in front and then behind, ensuring there's an equal distribution of past and future semesters.   
    
    @semesters = []
    @quantity.times {@semesters << generate_semester_data_hash}
  end
  
  def generate_semester_data_hash 
    start_date, end_date = generate_start_and_end_dates
    name = generate_semester_name(start_date)
    {name: name, start_date: start_date, end_date: end_date}
  end
  
  def generate_start_and_end_dates
    start_date, end_date = nil, nil
    
    if @occupied_date_ranges.empty? #No semesters created yet.
      start_date = (@days_long/2).days.ago
      end_date = (@days_long/2).days.from_now
    elsif @future #Current semester already set, tack a new semester on to the end of last semester tracked.
      start_date = @occupied_date_ranges.last.last + 1.day
      end_date = start_date + @days_long
      @future = false #Swap so next semester is created for the past.
    else#Current semester already set, tack a new semester before all other tracked semesters.
      end_date = @occupied_date_ranges.first.first - 1.day
      start_date = end_date - @days_long
      @future = true #Swap so next semester is created for the future.
    end
    
    track_date_range((start_date..end_date)) #Add new date range to tracked date ranges.
    return start_date, end_date #Return start and end dates.
  end
  
  def generate_semester_name(start_date)
    "#{season_for(start_date)} #{start_date.year} (#{@days_long} Days)"
  end
  
  def track_date_range(range)
    @occupied_date_ranges << range
    @occupied_date_ranges.sort_by! {|range| range.first} #Sorts ranges in ascending order.
  end
  
  def season_for(start_date)
    mid_point_month = (start_date + @days_long).month
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