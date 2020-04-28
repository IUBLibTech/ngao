Rails.application.routes.draw do
  concern :range_searchable, BlacklightRangeLimit::Routes::RangeSearchable.new
  mount Blacklight::Engine => '/'
  mount Arclight::Engine => '/'

  root to: 'catalog#index'
  concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
    concerns :range_searchable
  end

  devise_for :users

  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end

  get '/admin', to: 'admin#index', as: 'admin'
  get 'admin/index_eads', to: 'admin#index_eads', as: 'index_eads'
  get 'admin/index_repository', to: 'admin#index_repository', as: 'index_repository'
  get 'admin/index_ead', to: 'admin#index_ead', as: 'index_ead'
  delete 'admin/delete_user/:id', to: 'admin#delete_user', as: 'admin_delete_user'
  get 'admin/update_user_role/:id', to: 'admin#update_user_role', as: 'admin_update_user_role'
  get 'admin/edit_repository/:id', to: 'admin#edit_repository', as: 'admin_edit_repository'
  patch 'admin/update_repository/:id', to: 'admin#update_repository', as: 'admin_update_repository'

  authenticated :user do
    mount DelayedJobWeb, at: '/delayed_job'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
