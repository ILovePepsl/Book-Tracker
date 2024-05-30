Rails.application.routes.draw do
  scope "(:locale)", locale: /en|uk/ do
    devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)

    get 'goals/show'
    get 'goals/edit'
    get 'goals/update'
    get 'profiles/show'
    get 'profiles/edit'
    get 'profiles/update'
    get 'home/index'
    devise_for :users, controllers: { registrations: 'users/registrations' }

    resources :books do
      member do
        post :add_to_list
        post :set_status
      end
      resources :quotes, only: [:create, :destroy]
      resources :notes, only: [:create, :destroy]
    end

    resources :authors, only: [:index, :new, :create, :edit, :update, :destroy, :show] do
      collection do
        get :search
      end
    end

    resources :categories, only: [:index, :new, :create, :edit, :update, :destroy, :show] do
      collection do
        get :search
      end
    end

    resources :book_lists do
      member do
        delete :remove_book_from_list
      end
    end

    resources :achievements, only: [:index]
    resources :reading_calendars, only: [:index]
    resources :recommendations, only: [:index]
    resources :statistics, only: [:index]
    resource :profile, only: [:show, :edit, :update]
    resource :goal, only: [:show, :edit, :update]
    resources :general_library, only: [:index, :show] do
      member do
        post :add_to_my_library, to: 'general_library#add_to_my_library'
      end
    end

    root to: 'profiles#show'
  end
end
