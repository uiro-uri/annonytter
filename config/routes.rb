Rails.application.routes.draw do
  root 'tweets#new'
  resources :tweets do
    collection do
      get 'post'
      get 'review'
    end
  end
end