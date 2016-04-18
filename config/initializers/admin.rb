class CanAccessResque
  def self.matches?(request)
    current_user = request.env['warden'].user
    return false if current_user.blank?
    self.check(current_user)
  end


  def self.check(current_user)
    @current_permissions = Hash.new(Array.new)
    if current_user
      current_user.roles.each do |role|
        subject_class = ""
        temp = Array.new
        role.permissions.each do |perm|
          subject_class = perm.subject_class
          temp << perm.action
        end
        @current_permissions[subject_class] = temp
      end
    elsif @api_user
      @api_user.roles.each do |role|
        role.permissions.each do |perm|
          @current_permissions[perm.subject_class] << perm.action
        end
      end
    end
    if ((@current_permissions["resque"].include? "manage") || (@current_permissions["all"].include? "manage"))
      return true
    else
      return false
    end
  end

end
