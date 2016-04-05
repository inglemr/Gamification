class Organization < ActiveRecord::Base
  has_and_belongs_to_many :users


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
