class Semester < ActiveRecord::Base
  has_many :courses, dependent: :destroy
  
  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :does_not_overlap
  validate :ends_after_it_starts
  
  scope :starts_during, lambda {|semester| where(start_date: (semester.start_date..semester.end_date)).where.not(id: semester.id)}
  scope :ends_during, lambda {|semester| where(end_date: (semester.start_date..semester.end_date)).where.not(id: semester.id)}
  scope :overlaps, lambda {|semester| where('start_date <= ? and end_date >= ?', semester.start_date, semester.end_date).where.not(id: semester.id)}
  scope :current, lambda { where('start_date <= ? AND end_date >= ?', Date.today, Date.today).take}
  
  def over? #Determine whether or not a semester is over/in the past.
    end_date < Date.today
  end
  
  private
  def does_not_overlap
    unless Semester.starts_during(self).empty? and Semester.ends_during(self).empty? and Semester.overlaps(self).empty?
      errors.add(:base, 'A semester cannot overlap an existing semester.')
    end
  end
  
  def ends_after_it_starts
    unless start_date <= end_date
      errors.add(:base, 'A semester cannot end before it starts.')
    end
  end
end
