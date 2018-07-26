Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html



  root 'static_pages#index'
  resources(:courses, {only: [:index, :show]}) do
    resources(:enrollments, {only: [:create]}) #nest enrollments in courses namespace so you can slurp course_id from url params
  end

  resources(:lessons, {only: [:show]})


  #####------------------INSTRUCTOR NAMESPACE-----------------------#####
  #####                                                             #####
  namespace :instructor do                                          #####
                                                                    #####
    resources :lessons, only: [:update]
    resources :sections, only: [] do                                #####
      resources :lessons, only: [:new, :create]                     #####
    end                                                             #####
                                                                    #####                                                                    
    #nested inside instructor namespace                             #####
    resources :courses, only: [:new, :create, :show] do             #####
      resources :sections, only: [:new, :create] do                 #####
      end                                                           #####
    end                                                             #####
  end                                                               #####
  #####-------------------------------------------------------------#####

end
