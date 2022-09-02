module ApplicationHelper
  def field_errors(model, attribute, html_opts = {})
    html_class = html_opts.delete(:class) || "text-danger"

    if model.errors[attribute].any?
      content_tag :span, class: html_class do
        model.errors[attribute].to_sentence
      end
    end
  end

  def number_to_pesos(number)
    number_to_currency(number, unit: "PHP ")
  end

  def month_and_year_for_date(date)
    date.strftime("%B %Y")
  end

  def month_day_year_for_date(date)
    date.strftime("%B %d, %Y")
  end
end
