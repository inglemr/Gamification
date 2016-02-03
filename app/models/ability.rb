class Ability
  include CanCanNamespace::Ability
  def initialize(user)
    if user
      if user.roles
        user.roles.each do |role|
          role.permissions.each do |permission|
            if permission.subject_class == "all" || permission.subject_class == "sidebar" 
              can permission.action.to_sym, permission.subject_class.to_sym
              can permission.action.to_sym, permission.subject_class.to_sym, :context => :admin
            end
            if !permission.subject_class.include?("::")
              if permission.subject_class == "all"
                can permission.action.to_sym, permission.subject_class.to_sym
              elsif permission.subject_class == "Dashboard"
                can permission.action.to_sym, permission.subject_class.downcase.to_sym
              elsif permission.subject_class == "sidebar"
                can permission.action.to_sym, permission.subject_class.downcase.to_sym, :context => "admin"
              else
                can permission.action.to_sym, permission.subject_class.constantize
              end
            elsif permission.subject_class.include?("::")
              sub_array = permission.subject_class.split('::')
              if sub_array.first == "API"
                can permission.action.to_sym, sub_array.last.to_sym , :context => sub_array.first.downcase.to_sym
              elsif permission.action == "destory" || permission.action == "update"
                can permission.action.to_sym, sub_array.last.constantize, :created_by => user.id , :context => sub_array.first.downcase.to_sym
              else
                can permission.action.to_sym, sub_array.last.constantize , :context => sub_array.first.downcase.to_sym
              end
            end
          end
        end
      end
    end
  end
end
