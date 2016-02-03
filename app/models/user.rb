class User < ActiveRecord::Base
	after_commit :assign_default_role, on: :create
	has_and_belongs_to_many :roles
  has_many :created_events, :class_name => "Event", :foreign_key => "created_by"
  has_many :attended_events, through: :user_events, source: :event

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  scope :sorted, lambda { order("users.id ASC")}

  def assign_default_role
    self.roles << Role.find_by(:name => "Student") if self.roles.blank?
  end


  def add_role(role_name)
    role = Role.find_by(:name => role_name.to_s)
    if role
      if !(self.roles.exists?(role.id))
        self.roles << role
      else
        puts "User Already Has Role " + role_name
      end
    else
      puts "Role Does Not Exist"
    end
  end
end

  