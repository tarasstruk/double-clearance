module Clearance
  class Routes

    # In your application's config/routes.rb, draw Clearance's routes:
    #
    # @example
    #   map.resources :posts
    #   Clearance::Routes.draw(map)
    #
    # If you need to override a Clearance route, invoke your app route
    # earlier in the file so Rails' router short-circuits when it finds
    # your route:
    #
    # @example
    #   map.resources :users, :only => [:new, :create]
    #   Clearance::Routes.draw(map)
    def self.draw(map)
      map.resources :passwords,
        :controller => 'clearance/passwords',
        :only       => [:new, :create]


      map.resource  :user_session,
        :controller => 'user_sessions',
        :only       => [:new, :create, :destroy]

      map.resource  :admin_user_session,
        :controller => 'admin_user_sessions',
        :only       => [:new, :create, :destroy]



      map.resources :users, :controller => 'users' do |users|
        users.resource :password,
          :controller => 'clearance/passwords',
          :only       => [:create, :edit, :update]

        users.resource :confirmation,
          :controller => 'user_confirmations',
          :only       => [:new, :create]
      end


      map.resources :admin_users, :controller => 'admin_users' do |admin_users|
        admin_users.resource :password,
          :controller => 'clearance/passwords',
          :only       => [:create, :edit, :update]

        admin_users.resource :confirmation,
          :controller => 'admin_user_confirmations',
          :only       => [:new, :create]
      end


      map.sign_up  'sign_up',
        :controller => 'users',
        :action     => 'new'
      map.sign_in  'sign_in',
        :controller => 'user_sessions',
        :action     => 'new'
      map.sign_out 'sign_out',
        :controller => 'user_sessions',
        :action     => 'destroy',
        :method     => :delete  


      map.admin_sign_up  'admin_sign_up',
        :controller => 'admin_users',
        :action     => 'new'
      map.admin_sign_in  'admin_sign_in',
        :controller => 'admin_user_sessions',
        :action     => 'new'
      map.admin_sign_out 'admin_sign_out',
        :controller => 'admin_user_sessions',
        :action     => 'destroy',
        :method     => :delete



    end

  end
end
