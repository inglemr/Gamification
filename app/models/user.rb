#<%= SymmetricEncryption.decrypt (current_user.current_semester["GPA"]) %>
class User < ActiveRecord::Base
  extend FriendlyId
  include PublicActivity::Model
   serialize :notification_settings



  friendly_id :username, use: [:slugged, :history,:finders]

  #Validations
  before_validation :set_email, :on => :create
  #before_validation :generate_api_token

  #validates :api_token, presence: true, uniqueness: true
  validates :gsw_id, presence: true, uniqueness: {message: " must be unique"}
  validates :email , uniqueness: {message: "must be unique or does not exist"}
  validates :username, uniqueness: {message: " must be unique"}


  #Relationships
  #
  #
  has_many :articles
  has_many :requests
  has_many :organizations_users, foreign_key: :user_id
  has_many :organizations, through: :organizations_users

	has_and_belongs_to_many :roles
  has_many :user_events, foreign_key: :attendee_id
  has_many :created_events, :class_name => "Event", :foreign_key => "created_by"
  has_many :attended_events, through: :user_events

  has_many :request, foreign_key: :user_id
  has_many :user_org_roles, foreign_key: :user_id
  has_many :org_roles, foreign_key: :user_id, through: :user_org_roles, :source => 'org_role'

  has_many :host_events, foreign_key: :host_id
  has_many :hosted_events, through: :host_events, dependent: :destroy

  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,:confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable

  scope :sorted, lambda { order("users.id ASC")}
  def update_records(pin)
 require 'net/http'
      params = Hash.new
      params[:sid] = self.gsw_id
      params[:pin] = pin
      response = Net::HTTP.post_form(URI.parse("https://rainy.gswcm.net/rainer.php"), params)
      res = JSON.parse response.body

      if res["status"] == 0
         transcripts = res["transcripts"][0]
         if !transcripts["type"].nil?
          self.user_type = transcripts["type"]
          #   "summary": {
          #    "hours": "122.00",
          #    "points": "391.00",
          #    "GPA": "3.20"
          # },
          summary = transcripts["summary"]
          hours = summary["hours"]
          points = summary["points"]
          gpa = summary["GPA"]

          current_semester_enc = Hash.new
          current_semester_enc["hours"] = SymmetricEncryption.encrypt(hours)
          current_semester_enc["points"] = SymmetricEncryption.encrypt(points)
          current_semester_enc["GPA"] =  SymmetricEncryption.encrypt(gpa)
          self.current_semester =  current_semester_enc

          self.class_type = set_user_class(hours.to_f)
         end
         if !transcripts["last_semester"].nil?
          # "last_semester": {
          #    "term": "Fall 2015",
          #    "academic_standing": "Good Standing",
          #    "additional_standing": "Dean's List"
          # }
          #Unecrypted
          last_semester = transcripts["last_semester"]
          term = last_semester["term"]
          academic_standing = last_semester["academic_standing"]
          additional_standing = last_semester["additional_standing"]
          #ecrypted
          last_semester_enc = Hash.new
          last_semester_enc["term"] = SymmetricEncryption.encrypt(term)
          last_semester_enc["academic_standing"] =  SymmetricEncryption.encrypt(academic_standing)
          last_semester_enc["additional_standing"] =  SymmetricEncryption.encrypt(additional_standing)
          self.last_semester =  last_semester_enc
         end
      else
        return "Error Getting Records"
      end
      self.name = res["name"]
      self.save
      self.create_activity action: 'update_records',owner: self
      return "Success"
  end

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

         self.username = self.email.split('@').first

         transcripts = res["transcripts"][0]
         puts transcripts
         if !transcripts["type"].nil?
          self.user_type = transcripts["type"]

        #   "summary": {
        #    "hours": "122.00",
        #    "points": "391.00",
        #    "GPA": "3.20"
        # },
        summary = transcripts["summary"]
        hours = summary["hours"]
        points = summary["points"]
        gpa = summary["GPA"]

        current_semester_enc = Hash.new
        current_semester_enc["hours"] = SymmetricEncryption.encrypt(hours)
        current_semester_enc["points"] = SymmetricEncryption.encrypt(points)
        current_semester_enc["GPA"] =  SymmetricEncryption.encrypt(gpa)
          self.current_semester =  current_semester_enc

          self.class_type = set_user_class(hours.to_f)
          notification_settings = Hash.new
          notification_settings[:events] = true
          notification_settings[:organizations] = true
          notification_settings[:account] = true
          self.notification_settings = notification_settings
        end
        if !transcripts["last_semester"].nil?
          # "last_semester": {
          #    "term": "Fall 2015",
          #    "academic_standing": "Good Standing",
          #    "additional_standing": "Dean's List"
          # }
          #Unecrypted
          last_semester = transcripts["last_semester"]
          term = last_semester["term"]
          academic_standing = last_semester["academic_standing"]
          additional_standing = last_semester["additional_standing"]
          #ecrypted
          #This should be pulled out into a helper method that encrypts / decrypts a hash map
          last_semester_enc = Hash.new
          last_semester_enc["term"] = SymmetricEncryption.encrypt(term)
          last_semester_enc["academic_standing"] =  SymmetricEncryption.encrypt(academic_standing)
          last_semester_enc["additional_standing"] =  SymmetricEncryption.encrypt(additional_standing)
          self.last_semester =  last_semester_enc
        end
      else
        self.email = "notfound@email.com"
      end
      self.name = res["name"]
      self.points = 0
      self.gsw_pin = ""
  end



  def set_user_class(hours)
    if hours < 30
      return "Freshman"
    elsif hours >= 30 && hours < 60
      return "Sophomore"
    elsif hours >= 60 && hours < 90
      return "Junior"
    else
      return "Senior"
    end
  end

  def email_required?
    false
  end


  def assign_default_role
    self.points = 0;
    self.roles << Role.find_by(:name => "Student") if self.roles.blank?
    self.save
  end


  def remove_role(role_name)
  role = Role.find_by(:name => role_name.to_s)
  current_user ||= false
  if role
    if (self.roles.exists?(role.id))
      self.roles.delete(role.id)
      if current_user
        self.create_activity action: 'role_removed', parameters: {role: role.id},recipient: self, owner: current_user
      else
        self.create_activity action: 'role_removed', parameters: {role: role.id},recipient: self
      end
      if user.notification_settings[:account] == true
        UserMailer.removed_role(self,role).deliver_now
      end
    else
      puts "User Already Has Role " + role_name.to_s
    end
  else
    puts "Role Does Not Exist"
  end
  end

  def add_role(role_name)
    role = Role.find_by(:name => role_name.to_s)
    current_user ||= false
    if role
      if !(self.roles.exists?(role.id))
        self.roles << role
        if current_user
          self.create_activity action: 'role_added', parameters: {role: role.id},recipient: self, owner: current_user
        else
          self.create_activity action: 'role_added', parameters: {role: role.id},recipient: self
        end
        if user.notification_settings[:account] == true
          UserMailer.given_role(self,role).deliver_now
        end
      else
        puts "User Already Has Role " + role_name.to_s
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

  def self.to_csv(attributes,event)
    CSV.generate(headers: true) do |csv|
      cols = Array.new
      attributes.each do |col|
        if col == "email"
          cols << "Email"
        elsif col == "gsw_id"
          cols << "GSW ID"
        elsif col == "name"
          cols << "Student Name"
        elsif col =="class_type"
          cols << "Student Class"
        elsif col =="time"
          cols <<"Arrival Time"
        end
      end
      csv << cols

      all.each do |user|
        csv << attributes.map{ |attr| getCSVCol(user, attr,event) }
      end
    end
  end

  def self.getCSVCol(user, attr,event)
    if attr == "time"
       User.find_by_sql("SELECT users.id, user_events.created_at FROM users INNER JOIN user_events ON users.id = user_events.attendee_id WHERE users.id='#{user.id}' AND user_events.attended_event_id='#{event.id}'").first.created_at
    else
      user.send(attr)
    end
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
    update_attributes(p)
  end

  def has_no_password?
    self.encrypted_password.blank?
  end

  def only_if_unconfirmed
    pending_any_confirmation {yield}
  end


end


