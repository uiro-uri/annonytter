Rails.application.routes.draw do
  get 'users/new'

  root 'tweets#new'
  resources :tweets do
    collection do
      get 'post'
      get 'review'
    end
  end
end