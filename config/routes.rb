Rails.application.routes.draw do
	
  resources :books 
  resources :user_books
  
  ActiveAdmin.routes(self)
  root 'books#index'
  devise_for :users do
  get '/users/sign_out' => 'devise/sessions#destroy'
end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
