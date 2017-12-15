Rails.application.routes.draw do
  namespace :api do

#------------ resources shared between all the sites
    scope module: 'shared' do
      resources :images,  only: [:create, :show]
      resources :notes,   only: [:index, :show, :create, :destroy]

      resource :tags do
        get     ':type/:id',          to: 'tags#index'
        post    ':type/:id',          to: 'tags#create'
        get     ':type/:id/:tag_id',  to: 'tags#show'
      end

      resource :comments do
        get     ':type/:id',              to: 'comments#index'
        post    ':type/:id',              to: 'comments#create'
        delete  ':type/:id/:comment_id',  to: 'comments#destroy'
      end
    end

#------------ main site API
    scope module: 'main' do # same as "namespace :main do", but it will omit /main/ segment in paths

      #----- surveys
      namespace :surveys do
        resource :votings, path: '', only: [:public_surveys, :public_survey, :private_survey] do
          match 'public',             to: 'votings#random_public_survey', via: [:get]
          match 'public/all',         to: 'votings#all_public_surveys',   via: [:get]
          match 'public/:id',         to: 'votings#public_survey',        via: [:get]
          match 'private/:url_hash',  to: 'votings#private_survey',       via: [:get]

          match 'public/:id/vote',         to: 'votings#public_vote',     via: [:post]
          match 'private/:url_hash/vote',  to: 'votings#private_vote',    via: [:post]
        end

        resources :surveys, path: '', only: [:index, :show, :create, :start, :stop, :results, :destroy] do
          member do
            put 'start'
            put 'stop'
            get 'results'

            #----- survey_entities
            resource :entities, only: [:index, :create] do
              get '', to: 'entities#index'
              delete ':survey_entity_id', to: 'entities#destroy'
            end
          end
        end
      end
      #----- /surveys

      #----- users

      devise_for :users, module: 'devise',
         controllers: {
            registrations:  'api/main/users/registrations',
            confirmations:  'api/main/users/confirmations',
            passwords:      'api/main/users/passwords',
            sessions:       'api/main/users/auth'
         }

      namespace :users do
        match 'change_password',  to: 'accounts#change_password', via: [:put]
        match 'facebook_connect', to: 'facebook#connect',         via: [:post]

        #----- tinders
        resource :tinders, path: 'tinder', only: [:connect, :profiles] do
          post  'connect'
          get   'profiles'
        end
      end
      #----- /users

      #----- tools
      scope module: 'tools' do
        resources :dating_sites, only: [:index]
      end
      #----- /tools

    end
  end

  # Official examples:
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
