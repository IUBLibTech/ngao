class AdminController < ApplicationController
  before_action :authenticate_user!
  
  def index
  end

  def index_eads
    EadProcessor.import_eads
  end

end