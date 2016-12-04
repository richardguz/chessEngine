Rails.application.routes.draw do
  root 'static_pages#home'

  get '/games/:id', to: 'games#show'
  get '/games/:id/state', to: 'games#state'
  
  post '/games/:id/move', to: 'games#move'
	post '/games/new', to: 'games#new'
  post '/games/:id/join', to: 'games#join'
end
