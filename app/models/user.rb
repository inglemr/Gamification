class User < ActiveRecord::Base

  #Filters
  before_validation :set_email, :on => :create
  #before_validation :generate_api_token

  #Validations
  #validates :api_token, presence: true, uniqueness: true
  validates :gsw_id, presence: true, uniqueness: {message: " must be unique"}
  validates :email , uniqueness: {message: "must be unique or does not exist"}
 

  #Relationships
	has_and_belongs_to_many :roles
  has_many :user_events, foreign_key: :attendee_id
  has_many :created_events, :class_name => "Event", :foreign_key => "created_by"
  has_many :attended_events, through: :user_events

  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,:confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable

  scope :sorted, lambda { order("users.id ASC")}

  def set_email
    require 'net/http'
      params = Hash.new
      params[:sid] = self.gsw_id
      params[:pin] = self.gsw_pin
      response = Net::HTTP.post_form(URI.parse("https://rainy.gswcm.net/rainer.php"), params)
      res = JSON.parse response.body

      if res["status"] == 0
         emails = res["e-mails"]
         if emails["student"]
          self.email = emails["student"]
          self.roles << Role.find_by(:name => "Student")
         elsif emails["employee"]
          self.email = emails["employee"]
          self.roles << Role.find_by(:name => "Faculty")
         end
      else
        self.email = "notfound@email.com"
      end
      self.gsw_pin = ""
  end

  def email_required?
    false
  end


  def assign_default_role
    self.events_attended = 0;
    self.points = 0;
    self.roles << Role.find_by(:name => "Student") if self.roles.blank?
    self.save
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

  #def generate_api_token
  #  return if api_token.present?
  #  loop do
  #    self.api_token = SecureRandom.hex
  #    break unless User.exists? api_token: api_token
  #  end
  #end

  def password_required?
    false
  end

  def password_match?
    self.errors[:password] << "can't be blank" if password.blank?
    self.errors[:password_confirmation] << "can't be blank" if password_confirmation.blank?
    self.errors[:password_confirmation] << "does not match password" if password != password_confirmation
    password == password_confirmation && !password.blank?
  end

  def attempt_set_password(params)
    p = {}
    p[:password] = params[:password]
    p[:password_confirmation] = params[:password_confirmation]
    p[:username] = params[:username]
    update_attributes(p)
  end

  def has_no_password?
    self.encrypted_password.blank?
  end
 
  def only_if_unconfirmed
    pending_any_confirmation {yield}
  end


end

  