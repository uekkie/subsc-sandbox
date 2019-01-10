module V1
  module RequestHelper
    extend Grape::API::Helpers
    def authenticate!
      error!({message: 'Invalid Token', code: 401}, 401) unless current_user
    end

    def current_user
      header_token = request.headers["X-Access-Token"]
      token = ApiKey.where(access_token: header_token).first
      return false if token.blank? || !token.active
      @user = token.user
      @users = [token.user]
    end
  end
end
