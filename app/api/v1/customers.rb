module V1
  class Customers < Grape::API
    resource :customers, desc: 'customers', swagger: {nested: false} do
      helpers do
        def user_params
          ActionController::Parameters.new(params).permit(:name, :email, :password)
        end
      end
      desc "Creates customer"
      params do
        requires :name, type: String, desc: "Username"
        requires :email, type: String, desc: "Email"
        requires :password, type: String, desc: "Password"
      end
      
      post do
        email = params[:email]
        user = User.find_by_email(email)
        return {
          status: 400,
          user: user,
          message: 'Emailアドレスはすでに登録されています'
        } if user

        user = User.new(user_params)
        if user.save
          { 
            status: :created,
            user: user
          }
        end
      end
    end
  end
end
