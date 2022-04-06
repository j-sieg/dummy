module ApplicationHelper
  def field_errors(model, attribute, html_opts = {})
    html_class = html_opts.delete(:class) || "text-danger"

    if model.errors[attribute].any?
      content_tag :span, class: html_class do
        model.errors[attribute].to_sentence
      end
    end
  end
end
