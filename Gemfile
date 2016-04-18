source 'https://rubygems.org'
ruby "2.3.0"
gem 'rails', '4.2.4'
# Database
gem 'pg'

#Tagging
gem 'acts-as-taggable-on', '~> 3.4'

#User Authentication
gem 'devise'
gem 'bcrypt'
gem 'cancancan'
gem 'cancan_namespace'
gem 'symmetric-encryption'
#Used to create QR Codes
gem 'rqrcode'

#Used to create menu for user html editing
gem 'tinymce-rails'

#Pretty URLs
gem 'friendly_id', '~> 5.1.0'


#Background jobs
gem 'resque', :require => "resque/server"
gem 'resque-scheduler'
gem 'resque-pool'
gem 'resque-history'
gem 'resque-concurrent-restriction', :git => 'https://github.com/wr0ngway/resque-concurrent-restriction.git', :ref => 'b43082b'
#Assets
gem "chartkick"
gem "animate-rails"
gem "font-awesome-rails"
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'twitter-bootstrap-rails', :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git'
gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.17.37'
gem 'jquery-datatables-rails', github: 'rweng/jquery-datatables-rails'
gem 'jbuilder', '~> 2.0'
gem 'uglifier', '>= 1.3.0'
gem 'sprockets'
gem 'sass-rails'
gem 'will_paginate'
gem "sass"
gem "compass"
gem 'compass-rails'
gem 'coffee-rails', '~> 4.1.0'
gem 'turbolinks'
gem 'bootstrap-daterangepicker-rails'

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
