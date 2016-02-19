class Kiosk < ActiveRecord::Base
	attr_accessor :login
  validates :kiosk_name,
  :presence => true,
  :uniqueness => {
    :case_sensitive => true
  }

def self.authenticate(kiosk_id, gsw_pin)
  kiosk = Kiosk.where(:kiosk_name => kiosk_id).first
  user = User.where(:gsw_id => gsw_pin).first
  if kiosk && user
    kiosk
  else
    nil
  end
end
end
