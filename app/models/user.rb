class User < ActiveRecord::Base
	after_commit :assign_default_role, on: :create
  rolify
  has_many_with_set :events
  has_many :events, foreign_key: :user_id

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  scope :sorted, lambda { order("users.id ASC")}

  def assign_default_role
    self.add_role(:student) if self.roles.blank?
  end
end

  