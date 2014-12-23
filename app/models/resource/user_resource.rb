module Resource
  # Provides access to user resource.
  class UserResource < RegularResource

    protected

    def resource_class
      User
    end

    def permitted_params
      strong_parameters.require(:user).permit(
        if abilities.allowed? :write, User
          [:login, :email, :password, :password_confirmation, :admin, :publisher]
        else
          [:login, :email, :password, :password_confirmation]
        end
      )
    end
  end
end