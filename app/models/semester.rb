class Semester < ActiveRecord::Base
  has_many :courses, dependent: :destroy
  
  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :does_not_overlap
  
  scope :starts_during, lambda {|semester| where(start_date: (semester.start_date..semester.end_date))}
  scope :ends_during, lambda {|semester| where(end_date: (semester.start_date..semester.end_date))}
  
  private
  def does_not_overlap
    unless Semester.starts_during(self).empty? and Semester.ends_during(self).empty?
      errors.add(:base, 'A semester cannot overlap an existing semester.')
    end
  end
end
