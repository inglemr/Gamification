class ApiAbility
  include CanCan::Ability
	 def initialize(user)
	        user.roles.each do |role|
	            role.permissions.each do |permission|
	                if permission.subject_class == "all"
	                    can permission.action.to_sym, permission.subject_class.to_sym
	                elsif permission.subject_class == "Dashboard"
	                    can permission.action.to_sym, permission.subject_class.downcase.to_sym
	                elsif permission.subject_class.include? "API"
	                	can permission.action.to_sym, permission.subject_class.split('::').last.constantize.name 
	                else
	                  can permission.action.to_sym, permission.subject_class.constantize
	                end
	            end
	        end
	    end
end