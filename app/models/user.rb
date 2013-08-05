class User < ActiveRecord::Base
  validates :first_name, presence: true, length: {maximum: 25}, on: :create
  validates :last_name, presence: true, length: {maximum: 25}, on: :create
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}, on: :create
  validates :password, presence: true, confirmation: true, on: :create
  validates :password_confirmation, presence: true, on: :create
  
  has_secure_password
  
  before_save {|user| user.email.downcase!}
  
  def full_name
    [first_name, last_name].join(' ')
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
  
  def self.inherited(child)
    child.instance_eval do
      def model_name #Necessary to enable Rails to guess routes for an STI-based object.
        User.model_name
      end
    end
    super
  end
end