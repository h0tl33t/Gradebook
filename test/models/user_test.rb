require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'invalid without first name' do
    user = FactoryGirl.build(:user, first_name: nil)
    refute user.valid?, 'Not validating presence of first name.'
  end
  
  test 'first name must be no longer than 25 characters' do
    user = FactoryGirl.build(:user, first_name: ''.ljust(26,'x'))
    refute user.valid?, 'Not validating length of first name.'
  end
  
  test 'invalid without last name' do
    user = FactoryGirl.build(:user, last_name: nil)
    refute user.valid?, 'Not validating presence of first name.'
  end
  
  test 'last name must be no longer than 25 characters' do
    user = FactoryGirl.build(:user, last_name: ''.ljust(26,'i'))
    refute user.valid?, 'Not validating length of last name.'
  end
  
  test 'invalid without an email' do
    user = FactoryGirl.build(:user, email: nil)
    refute user.valid?, 'Not validating presence of email.'
  end
  
  test 'email only valid if correctly formatted' do
    user = FactoryGirl.build(:user, email: 'blah')
    refute user.valid?, 'Not validating format of email.'
  end
  
  test 'email should be downcased automatically before save' do
    user = FactoryGirl.build(:user, email: 'WOW@LOL.com')
    user.save
    assert_equal 'wow@lol.com', user.email, 'Not automatically downcasing email.'
  end
  
  test 'email must be unique in order to save' do
    user1 = FactoryGirl.create(:user)
    assert_raise(ActiveRecord::RecordInvalid) {FactoryGirl.create(:user)}
  end
  
  test 'user invalid without a password' do
    user = FactoryGirl.build(:user, password: nil)
    refute user.valid?, 'Not validating presence of password.'
  end
  
  test 'user invalid without password confirmation' do
    user = FactoryGirl.build(:user, password_confirmation: nil)
    refute user.valid?, "Not validating presence of password confirmation."
  end
  
  test 'user should be valid with all attributes' do
    user = FactoryGirl.create(:user)
    assert user.valid?, 'User not valid with all attributes.'
  end
end
