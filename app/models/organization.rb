class Organization < ActiveRecord::Base
  extend FriendlyId
  include PublicActivity::Model
  mount_uploader :image, ImageUploader

  friendly_id :name, use: [:slugged, :history,:finders]


  has_many :organizations_users, foreign_key: :organization_id
  has_many :users, through: :organizations_users

  has_many :events

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

  def add_leader(user,role)
    if !user.organizations.all.include?(self)
      self.create_activity action: 'first_member', owner: user
      self.users << user
      user.save
      user.org_roles << role
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
