class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  include Blacklight::LocalePicker::Concern
  layout :determine_layout if respond_to? :layout

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || admin_path
  end

  def after_accept_path_for(resource)
    stored_location_for(resource) || admin_path
  end

  def after_invite_path_for(resource)
    stored_location_for(resource) || admin_path
  end
end
