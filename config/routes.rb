Rails.application.routes.draw do
  root 'tweets#new'
  resources :tweets do
    collection do
      get 'post'
      get 'vote'
    end
  end
end