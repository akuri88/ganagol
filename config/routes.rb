Ganagol::Application.routes.draw do
	resources :users
	resources :sessions, only: [:new, :create, :destroy]
	
	match '/signin',  to: 'sessions#new'
	match '/signout', to: 'sessions#destroy'

	root to: 'sessions#new'
end
