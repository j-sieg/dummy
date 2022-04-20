# Load the Rails application.
require_relative "application"

# Remove the field_with_errors wrapper when
# rendering forms with models that have errors
ActionView::Base.field_error_proc = proc do |html_tag, _instance|
  html_tag.html_safe
end

# Initialize the Rails application.
Rails.application.initialize!
