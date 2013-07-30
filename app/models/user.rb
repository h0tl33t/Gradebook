class User < ActiveRecord::Base
  validates :first_name, presence: true, length: {maximum: 25}
  validates :last_name, presence: true, length: {maximum: 25}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}, confirmation: true
  
  has_secure_password
  
  before_save {|user| user.email.downcase!}
  
  def self.types
    self.descendants
  end
  
  #def self.inherited(subclass)
  #  update_column(:type, subclass)
  #end
end

#Require statements to load necessary files so User.types (alias of Class.descendents for User) returns valid values.
require 'admin'
require 'teacher'
require 'student'