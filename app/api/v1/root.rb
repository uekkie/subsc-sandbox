module V1
  class Root < Grape::API
    version 'v1'
    format :json

    rescue_from :all do |e|
      Root.logger.error(e.message.to_s << "\n" << e.backtrace.join("\n"))
      error!({ message: "Server Error"}, 500)
    end

    # Each APIs
    mount V1::Users
    mount V1::Auth
    mount V1::Customers
    mount V1::Subscriptions

    # swagger doc
    add_swagger_documentation(
      api_version: "v1",
      base_path: "/",
      # base_path: "#{ENV['API_BASE_PATH']}",
      hide_documentation_path: true,
      info: {
        title: "APIドキュメント",
        description: "説明です。"
      }
    )
  end
end
