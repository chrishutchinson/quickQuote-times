Rails.application.routes.draw do

  get 'welcome/index'

  get 'auth/:provider/callback', to: 'sessions#create'

  delete '/logout', to: 'sessions#destroy', as: :logout

  post 'save_quote' =>'quotes#save_quote_with_video_snippet'

  resources :users do 
    resources :videos
  end 

  root 'welcome#index'
end
