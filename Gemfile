source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '4.0.0'
gem 'sass-rails', '~> 4.0.0'
gem 'bootstrap-sass'
gem 'uglifier', '>= 1.3.0' #Compressor for JavaScript assests
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2' #For building JSON APIs (https://github.com/rails/jbuilder)
gem 'bcrypt-ruby', '~> 3.0.0', require: 'bcrypt'

group :development, :test do
  gem 'sqlite3'
  gem 'turn'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'pry-rails'
end

group :production do
  gem 'pg'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

gem 'rails_12factor', group: :production #For Heroku deployment of Rails 4 app.




