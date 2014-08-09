module ApplicationHelper
  def error_messages_for(*objects)
    if errors_list = objects.map { |object| object.errors.full_messages.map { |message| content_tag(:li, message) }.join("\n").html_safe if object }.join("\n").strip.html_safe 
      if errors_list.length > 0
        errors_list = content_tag(:h2, "Form is invalid") + content_tag(:ul, errors_list)
        content_tag(:div, errors_list.html_safe, :id => :error_explanation)
      end
    end
  end
end
