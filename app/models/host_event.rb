class HostEvent < ActiveRecord::Base
  belongs_to :host, class_name: 'User'
  belongs_to :hosted_event, class_name: 'Event'
end
