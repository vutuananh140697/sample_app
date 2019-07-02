Rails.application.routes.draw do
  root 'static_pages#home'
  get 'static_pages/home'
  get 'static_pages/help'
  get  'static_pages/about'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  Rails.application.routes.draw do
    scope "(:locale)", locale: /en|vi/ do
      resources :microposts
      resources :users
    end
  end
end
