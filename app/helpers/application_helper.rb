module ApplicationHelper  



    def mobile_device?
      request.user_agent =~ /Mobile|webOS|Raspbian/
    end

  def current_host
    return unless session[:current_host]
    @current_host ||= User.find(session[:current_host])
  end

	def current_class?(test_path)
    	return 'active' if request.path == test_path
    	''
  	end

    def bootstrap_class_for flash_type
        { success: "#468847", error: "#b94a48", alert: "#c09853", notice: "#346597" }[flash_type.to_sym] || flash_type.to_s
    end

  	def flash_messages(opts = {})
      test = ""
      flash.each do |msg_type, message|
      end
      test
    end

end

module ActionView
  module Helpers
    class FormBuilder 
      def date_select(method, options = {}, html_options = {})
        existing_date = @object.send(method) 

        # Set default date if object's attr is nil
        existing_date ||= Time.now.to_date

        formatted_date = existing_date.to_date.strftime("%m/%d/%Y") if existing_date.present?
        @template.content_tag(:div, :class => "input-group") do    
          text_field(method, :value => formatted_date, :class => "form-control datepicker", :"data-date-format" => "%m/%d/%Y %I:%M %p") +
          @template.content_tag(:span, @template.content_tag(:span, "", :class => "glyphicon glyphicon-calendar") ,:class => "input-group-addon")
        end
      end

      def datetime_select(method, options = {}, html_options = {})
        existing_time = @object.send(method) 

        # Set default date if object's attr is nil
        existing_date ||= Time.now

        formatted_time = existing_time.to_time.strftime("%m/%d/%Y %I:%M %p") if existing_time.present?
        @template.content_tag(:div, :class => "input-group") do    
          text_field(method, :value => formatted_time, :class => "form-control datetimepicker", :"data-date-format" => "%m/%d/%Y %I:%M %p") +
          @template.content_tag(:span, @template.content_tag(:span, "", :class => "glyphicon glyphicon-calendar") ,:class => "input-group-addon")
        end
      end
    end
  end
end


