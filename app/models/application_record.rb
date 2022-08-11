class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  delegate :dom_id, to: ActionView::RecordIdentifier
end
