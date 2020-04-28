class AdminController < ApplicationController
  before_action :authenticate_user!

  def index
    EadProcessor.get_repository_names
    @users = User.all
    @repositories = current_user.admin? ? Repository.all : current_user.repositories
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

  def edit_repository
    @user = User.find(params[:id])
    @repositories = Repository.all
  end

  def update_repository
    @user = User.find(params[:user_id])
    @user.update(admin_user_params)
    if @user.save
      redirect_to admin_path, notice: 'Repositories were successfully assigned'
    else
      redirect_to admin_path, notice: 'User repositories were not updated'
    end
  end

  private

  def admin_user_params
    params.require(:user).permit(repository_ids: [])
  end
end
