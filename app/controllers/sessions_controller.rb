class SessionsController < ApplicationController
    
  def create
    user = User.find_by!(username: params[:username])
    if user
      if user&.authenticate(params[:password])
        session[:user_id] = user.id
        render json: user, status: :created
      else
        # byebug
        render json: {errors: user.errors.full_messages}, status: :unauthorized
      end
    end
  
    # byebug
    render json: { errors: [] }, status: 401
  end

  def destroy
    if session[:user_id]
      session.delete :user_id
      head 204
    else
      render json: { errors: ["Unauthorized"]}, status: 401
    end
  end
end
