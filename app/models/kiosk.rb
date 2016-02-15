class Kiosk < ActiveRecord::Base
	attr_accessor :login
  validates :email, :presence => false, :email => false
  validates :kiosk_name,
  :presence => true,
  :uniqueness => {
    :case_sensitive => true
  }
	validates_format_of :kiosk_name, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:kiosk_name]


  def kiosk_name=(kiosk_name)
    @kiosk_name = kiosk_name
  end

  def login
    @kiosk_name || self.kiosk_name
  end 

    def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if kiosk_name = conditions.delete(:kiosk_name)
        where(conditions.to_hash).where(["kiosk_name = :value", { :value => kiosk_name }]).first
      elsif conditions.has_key?(:kiosk_name)
        where(conditions.to_hash).first
      end
    end
def email_required?
  false
end

def email_changed?
  false
end

end
