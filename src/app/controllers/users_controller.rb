class UsersController < ApplicationController

    def new
        @user = User.new
    end

    def create
        user = User.new(user_params)
        if user.save
          flash[:notice] = "ユーザー登録完了"
          redirect_to root_path
        else
          flash[:error_messages] = user.errors.full_messages
          redirect_back fallback_location: new_user_path
        end
    end

    private

    # 受け入れるデータの制御
    def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
