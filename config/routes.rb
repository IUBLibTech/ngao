Rails.application.routes.draw do
  concern :range_searchable, BlacklightRangeLimit::Routes::RangeSearchable.new
  mount Blacklight::Engine => '/'
  mount Arclight::Engine => '/'

  root to: 'arclight/repositories#index'
  concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
    concerns :range_searchable
  end

  if ENV['AL_AUTHN'] == 'database'
    devise_for :users
  else
    devise_for :users, controllers: { sessions: 'users/sessions', omniauth_callbacks: "users/omniauth_callbacks" },
                         skip: [:sessions, :passwords, :registration]
    devise_scope :user do
      get 'users/auth/cas', to: 'users/omniauth_authorize#passthru', defaults: { provider: :cas }, as: "new_user_session"
      get('global_sign_out',
          to: 'users/sessions#global_logout',
          as: :destroy_global_session)
      get "users/auth/cas",
          to: 'users/omniauth_authorize#passthru',
          defaults: { provider: :cas }, as: "new_cas_user_session"
    end
  end

  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  get '/admin', to: 'admin#index', as: 'admin'
  get 'admin/index_eads', to: 'admin#index_eads', as: 'index_eads'
  get 'admin/index_repository', to: 'admin#index_repository', as: 'index_repository'
  get 'admin/index_ead', to: 'admin#index_ead', as: 'index_ead'
  get 'admin/delete_ead', to: 'admin#delete_ead', as: 'delete_ead'
  delete 'admin/delete_user/:id', to: 'admin#delete_user', as: 'admin_delete_user'
  get 'admin/update_user_role/:id', to: 'admin#update_user_role', as: 'admin_update_user_role'
  get 'admin/edit_repository/:id', to: 'admin#edit_repository', as: 'admin_edit_repository'
  patch 'admin/update_repository/:id', to: 'admin#update_repository', as: 'admin_update_repository'

  authenticated :user do
    mount DelayedJobWeb, at: '/delayed_job'
  end

  get '/about', to: 'pages#about', as: 'about'
  get '/contribute', to: 'pages#contribute', as: 'contribute'
  get '/help', to: 'pages#help', as: 'help'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
