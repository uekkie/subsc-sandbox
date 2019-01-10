module V1
  class Auth < Grape::API
    helpers RequestHelper
    resource :auth, desc: 'auth', swagger: {nested: false} do

      # POST /v1/auth
      desc "Creates and returns access_token if valid login"
      params do
        requires :login, type: String, desc: "Username or email address"
        requires :password, type: String, desc: "Password"
      end
      
      post :login do
        if params[:login].include?("@")
          user = User.find_by_email(params[:login].downcase)
        else
          user = User.find_by_name(params[:login].downcase)
        end

        if user && user.authenticate(params[:password])
          key = ApiKey.where(user_id: user.id).order(created_at: :desc).take
          if key.nil? || key.expired? then
            key = ApiKey.create(user_id: user.id)
          end
          return {token: key.access_token} unless key&.expired?

          key = ApiKey.create(user_id: user.id)
          {token: key.access_token}
        else
          error!('Unauthorized.', 401)
        end
      end

      # GET /v1/ping
      desc "Returns pong if logged in correctly"
      get :ping do
        authenticate!
        { message: "pong" }
      end
    end
  end
end
