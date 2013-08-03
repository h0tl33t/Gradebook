class User < ActiveRecord::Base
  validates :first_name, presence: true, length: {maximum: 25}
  validates :last_name, presence: true, length: {maximum: 25}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, presence: true, confirmation: true, on: :create
  validates :password_confirmation, presence: true
  
  has_secure_password
  
  before_save {|user| user.email.downcase!}
  
  def full_name
    [first_name, last_name].join(' ')
  end
  
  def courses_for(semester)
    Course.for_semester(semester)
  end
  
  def self.types
    [Admin, Teacher, Student]
  end
  
  def admin?
    false
  end
  
  def teacher?
    false
  end
  
  def student?
    false
  end
  /
  def method_missing(name, *args)
    if name.to_s.last == '?' #Catch unknown boolean methods.
      class_name = name.to_s.delete('?').capitalize.constantize #Classify the method name.
      #Check to see if the Classify'd method name is a subclass of User (Admin, Teacher, Student).  If so, check if caller.class == class_name.  Else, super.
      User.types.include?(class_name) ? self.class == class_name : super
      #Enables us to dynamically check if a current user is a certain User type: current_user.admin?, current_user.teacher?, current_user.student?
    else
      super
    end
  end/
end