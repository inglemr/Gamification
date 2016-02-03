class ApiAbility
  include CanCan::Ability
	 def initialize(user)
	  user.roles.each do |role|
	    role.permissions.each do |permission|
	      if permission.subject_class == "all"
	        can permission.action.to_sym, permission.subject_class.to_sym
	      end
	     	if permission.subject_class.include?("API")
	        can permission.action.to_sym, permission.subject_class.split('::').last.downcase.to_sym
	      end
	    end
	  end
	 end
end