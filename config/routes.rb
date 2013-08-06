Gradebook::Application.routes.draw do
  root 'home#index'
  
  resources :semesters do
    resources :courses
    resources :enrollments
  end

  resources :users
  
  resources :sessions, only: [:new, :create, :destroy]
  get '/signin', to: 'sessions#new'
  get '/signout', to: 'sessions#destroy'
  get '/signup', to: 'users#new'
  
  get '*a' => redirect { |page, request| request.flash[:error] = "The page for #{page[:a]} was not found."; '/'}
  #Redirect to home with an error notice for all routes not found.
end
