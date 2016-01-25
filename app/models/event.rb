class Event < ActiveRecord::Base
  resourcify
  belongs_to :users
end
