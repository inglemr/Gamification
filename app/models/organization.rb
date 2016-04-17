class Organization < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history,:finders]

  has_and_belongs_to_many :users
  has_many :org_roles, foreign_key: :org_id,dependent: :destroy
  has_many :request, foreign_key: :organization_id


  def add_member(user)
    if !user.organizations.all.include?(self)
      self.users << user
      user.save
      self.save
      true
    else
      false
    end
  end

  def remove_member(user)
    if user.organizations.all.include?(self)
      self.users.delete(user)
      user.save
      self.save
      true
    else
      false
    end
  end


end
