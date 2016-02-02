source 'https://rubygems.org'
ruby "2.2.3"
gem 'rails', '4.2.4'
# Database
gem 'pg'
gem 'has-many-with-set'

#User Authentication
gem 'devise'
gem 'bcrypt'
gem 'cancancan'
gem 'cancan_namespace'

#Used to create QR Codes
gem 'rqrcode'

#Assets
# Use jquery as the JavaScript library
gem "font-awesome-rails"
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.17.37'
gem 'jquery-datatables-rails', github: 'rweng/jquery-datatables-rails'
gem 'jbuilder', '~> 2.0'
gem 'will_paginate'
gem 'uglifier', '>= 1.3.0'
gem 'sass-rails', '~> 5.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'turbolinks'
gem 'gridster-rails'

#File uploads
gem 'carrierwave'
gem "mini_magick"

group :production do
	#Web Server
	gem "passenger"
	#Used by heroku
	gem 'rails_12factor'
end
group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end
