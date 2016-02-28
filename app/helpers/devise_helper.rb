module DeviseHelper
  def devise_error_messages!
    return "" if resource.errors.empty?

    messages = ""
    resource.errors.messages.each do |key, msg|
      msg.each do |error|
        if error == "has already been taken"

        elsif key.to_s == "email"
          messages += "Student Account " + error + "<br>"
        elsif key.to_s == "gsw_id"
          messages += "GSW ID" + error + "<br>"
        else
          messages += key.to_s.capitalize + " " + error + "<br>"
        end
      end
    end
    flash[:alert] = messages.html_safe
    ""
  end

  def devise_error_messages?
    resource.errors.empty? ? false : true
  end

end