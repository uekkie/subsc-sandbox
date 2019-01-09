module API
  class Root < Grape::API
    mount V1::Root
    # mount Auth
  end
end
