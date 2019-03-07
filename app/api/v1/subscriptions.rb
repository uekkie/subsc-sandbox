module V1
  class Subscriptions < Grape::API
    content_type :xml, 'application/xml'
    formatter :xml, Proc.new { |object|
      object[object.keys.first].to_xml :root => object.keys.first
    }
    format :xml # We don't like xml anymore
    resource :subscriptions, desc: 'subscriptions', swagger: {nested: false} do
      helpers do
        def subscription_params
          ActionController::Parameters.new(params).permit( :email)
        end
      end
      desc "ユーザーのサブスクリプション情報の取得"
      params do
        requires :email, type: String, desc: "Email"
      end

      get do
        source = <<EOF
<?xml version="1.0"?> 

<spoffer>
<item>
<long>46634653D1AE33AD</long>
         <bool>45474533DD1E714D</bool>
<short/>
<byte>4647443747374633DD7E789D783F81AD</byte>
         <float>4533DD1D</float>
<single>4547714D</single>
         <word>4647473747374533DD1DA89D789D91AD</word>
<double/>
<real>46474433DD1F81AD</real>
     </item>
</spoffer>
EOF

        spoffer= {
          spoffer:{
            item: {
              long: "46634653D1AE33AD",
              bool:"45474533DD1E714D",
              short: "",
              byte: "4647443747374633DD7E789D783F81AD",
              float: "4533DD1D",
              single: "4547714D",
              word: "4647473747374533DD1DA89D789D91AD",
              double: "",
              real: "46474433DD1F81AD"
            }
          }
        }

        spoffer
      end
    end
  end
end

