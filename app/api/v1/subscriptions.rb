module V1
  class Spoffer
# ・BASE64エンコードする    27764 -> "Mjc3NjQ="
# ・バイト列にする       => [77, 106, 99, 51, 78, 106, 81, 61]
# ・16進数コード表現に変換   "4D6A63334E6A513D"
# ・暗号化文字列の中央に挿入  "46634653D1AE33AD"
# "46634653D1AE33AD"  "27764"
    def enc(str)
      left=[]
      right=[]
      base64_hexies = Base64.encode64(str).chomp.unpack('H*').first.upcase.split(//)
      until base64_hexies.empty? do
        left.push     base64_hexies.shift
        right.unshift base64_hexies.shift
      end
      (left << right).join
    end

    def dec(str)
      chars = str.split(//)
      base64ed=""
      until chars.empty? do
        # 2文字区切りで16進から文字に変換
        base64ed << (chars.shift + chars.pop).hex.chr
      end
      Base64.decode64(base64ed)
    end
  end

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
        user = User.find_by_email(params[:email])
        return spoffer= {
          spoffer:{}
        } unless user

        conv = Spoffer.new
        started_at = "2019/03/09"
        expired_at = "2019/04/10"
        spoffer= {
          spoffer:{
            item: {
              long: conv.enc("27764"),
              char: conv.enc(user.name),
              byte: conv.enc(started_at),
              float: conv.enc("1"),
              bool: conv.enc("2001"),
              single: conv.enc("110"),
              short: "",
              word: conv.enc(expired_at),
              double: "",
              real: conv.enc("1")
            }
          }
        }

        spoffer
      end
    end
  end
end

