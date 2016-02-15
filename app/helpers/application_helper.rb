module ApplicationHelper  

	def current_class?(test_path)
    	return 'active' if request.path == test_path
    	''
  	end

    def bootstrap_class_for flash_type
        { success: "alert-success", error: "alert-error", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || flash_type.to_s
    end

  	def flash_messages(opts = {})
    	flash.each do |msg_type, message|
      	concat(content_tag(:div, message, class: "row col-md-4 col-md-offset-8 flash_msg alert " +  bootstrap_class_for(msg_type) + " fade in") do 
              concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
              concat message 
            end)
    	end
    	nil
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


