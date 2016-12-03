Rails.application.routes.draw do
  root 'static_pages#home'
  post '/games/new', to: 'games#new'
  post '/games/:id/join', to: 'games#join'
  get '/games/:id', to: 'games#show'
  get '/games/:id/state', to: 'games#state'
end
