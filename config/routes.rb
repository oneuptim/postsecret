Rails.application.routes.draw do
  get '/secrets' => 'users#index'

  get '/register' => 'users#register'

  post '/register' => 'users#create'

  get '/login' => 'users#login'

  post '/users/auth' => 'users#auth'

  get '/users/:id' => 'users#show'

  get '/logout' => 'users#clearSession'

  post '/post_secret' => 'users#create_secret'

  get '/delete/:id' => 'users#delete_secret'

  post '/like_secret/:id' => 'users#like_secret'

  post '/unlike_secret/:id' => 'users#unlike_secret'

  # users_index GET  /users/index(.:format)    users#index
  # users_show GET  /users/show(.:format)     users#show
  # users_login GET  /users/login(.:format)    users#login
  # users_register GET  /users/register(.:format) users#register
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
