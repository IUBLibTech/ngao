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

  def delete_user
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_path, notice: 'User has been deleted.' if @user.destroy
  end

  def update_user_role
    @user = User.find(params[:id])
    @user.role == 'manager' ? @user.role = 'admin' : @user.role = 'manager'
    @user.save

    if @user.save
      redirect_to admin_path, notice: 'User role has been updated'
    else
      redirect_to admin_path, notice: 'User was not updated'
    end
  end
end
