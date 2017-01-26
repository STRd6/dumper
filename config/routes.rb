Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :contents, :accounts

  match "/register" => "welcome#register", :via => :post
  match "/auth" => "welcome#auth", :via => :get

  root to: "welcome#index"
end
