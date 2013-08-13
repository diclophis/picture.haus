Centerology::Application.routes.draw do
  devise_for :people

  root :to => 'welcome#index'

  get 'feeds/:username' => 'welcome#feed', :as => :feed

  resources :friendships

  resources :images, :only => [:show]

  resources :findings, :only => [:create, :new]
end
