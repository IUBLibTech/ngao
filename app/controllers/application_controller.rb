class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  include Blacklight::LocalePicker::Concern
  layout :determine_layout if respond_to? :layout

  def default_url_options(opts={})
    opts.merge(Ngao::Application.config.action_mailer.default_url_options || {})
  end

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
