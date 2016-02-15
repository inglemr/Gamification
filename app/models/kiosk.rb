class Kiosk < ActiveRecord::Base
	attr_accessor :login
validates :username,
  :presence => true,
  :uniqueness => {
    :case_sensitive => true
  }
	validate :validate_username
	validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:login]


  def login=(login)
    @login = login
  end

  def login
    @login || self.kiosk_name || self.email
  end 

    def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions.to_hash).where(["name = :value OR lower(email) = :value", { :value => login }]).first
      elsif conditions.has_key?(:kiosk_name) || conditions.has_key?(:email)
        where(conditions.to_hash).first
      end
    end
def validate_username
  if User.where(email: kiosk_name).exists?
    errors.add(:kiosk_name, :invalid)
  end
end

end
