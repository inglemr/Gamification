class AdminAbility
  include CanCan::Ability
	 def initialize(user)
	  user.roles.each do |role|
	    role.permissions.each do |permission|
	      if permission.subject_class == "all" || permission.subject_class == "sidebar" 
	        can permission.action.to_sym, permission.subject_class.to_sym
	      end
	      if permission.subject_class.include?("Admin")
	        can permission.action.to_sym, permission.subject_class.split('::').last.constantize
	      end
	    end
	  end
	end  
end