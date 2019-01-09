module V1
  class UsersEntity < Grape::Entity
    expose :id, documentation: {type: Integer, desc: "ユーザーid"}
    expose :email, documentation: {type: String, desc: "メールアドレス"}
    expose :name, documentation: {type: String, desc: "名前"}
    expose :stripe_id, documentation: {type: String, desc: "Stripe id"}
    expose :created_at, documentation: {type: String, desc: "作成日時"}
    expose :updated_at, documentation: {type: String, desc: "更新日時"}
  end

  class Users < Grape::API
    helpers RequestHelper

    resource 'users', desc: 'ユーザー', swagger: { nested: false } do
      # GET /v1/users
      desc 'ユーザーリストの取得', {
        entity: UsersEntity,
        response: {isArray: true, entity: UsersEntity}
        #headers: [...],
        #errors: [...]
      }
      get do
        authenticate!
        present @users, with: UsersEntity
      end
    end
  end
end
