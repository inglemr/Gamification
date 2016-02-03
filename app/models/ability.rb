class Ability
  include CanCan::Ability
  def initialize(user)
    if user
      if user.roles
        user.roles.each do |role|
          role.permissions.each do |permission|
            if !permission.subject_class.include?("::")
              if permission.subject_class == "all"
                can permission.action.to_sym, permission.subject_class.to_sym
              elsif permission.subject_class == "Dashboard" || permission.subject_class == "sidebar" || permission.subject_class == "Event"
                can permission.action.to_sym, permission.subject_class.downcase.to_sym
              else
                can permission.action.to_sym, permission.subject_class.constantize
              end
            end
          end
        end
      end
    end
  end
end
