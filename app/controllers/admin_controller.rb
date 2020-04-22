class AdminController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
    @repositories = EadProcessor.get_repository_names
  end

  def index_eads
    EadProcessor.delay.import_eads
  end

  def index_repository
    repository = params[:repository]
    EadProcessor.delay.import_eads({ files: [repository] })
  end

  def index_ead
    repository = params[:repository]
    file = params[:ead]
    args = { ead: file, repository: repository }
    EadProcessor.delay.index_single_ead(args)
  end
end
