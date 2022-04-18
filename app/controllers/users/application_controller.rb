module Users
  class ApplicationController < ::ApplicationController
    # Base controller for any controller that requires a User
    # to be authenticated
    before_action :require_user_authentication!
  end
end
