class ApplicationController < ActionController::Base
  include UserAuthentication

  def up
    head :ok
  end
end
