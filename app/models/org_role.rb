class OrgRole < ActiveRecord::Base
  belongs_to :user, class_name: 'User'
  belongs_to :org, class_name: 'Organization'
end
