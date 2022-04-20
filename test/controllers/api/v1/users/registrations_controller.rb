module Api::V1::Users
  class RegistrationsController
    def create
    end

    def destroy
    end

    private

    def user_params
      params.require(:user).permit(:email, :password)
    end
  end
end
