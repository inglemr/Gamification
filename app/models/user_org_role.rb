class UserOrgRole < ActiveRecord::Base
  belongs_to :user, class_name: 'User'
  belongs_to :org_role, class_name: 'OrgRole'
end
