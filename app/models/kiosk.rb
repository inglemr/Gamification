class Kiosk < ActiveRecord::Base
	attr_accessor :kisok_name
  validates :email, :presence => false, :email => false
  validates :kiosk_name,
  :presence => true,
  :uniqueness => {
    :case_sensitive => true
  }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:kiosk_name]

def email_required?
  false
end

def email_changed?
  false
end

end
