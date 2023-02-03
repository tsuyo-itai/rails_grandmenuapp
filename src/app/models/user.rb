class User < ApplicationRecord
    # これを追加することで password属性とpassword_confirmation属性がモデルに追加される
    has_secure_password

    # ユーザー名をuniqueだとか形式だとか
    validates :email,
        presence: true,
        # uniqueness: { case_sensitive: false }で、一意性とメールアドレスの大文字・小文字の区別を無くしている
        uniqueness: {
          case_sensitive: false
        },
        format: {
          with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i,
          message: 'は不正な形式です'
        }
    # パスワードは最低8文字とか、その程度
    validates :password,
        length: { minimum: 8 }
end
