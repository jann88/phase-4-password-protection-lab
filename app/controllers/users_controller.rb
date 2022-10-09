class UsersController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessible_entity
    def create
        user = User.create!(user_params)
        session[:user_id] = user.id
        render json: user, status: 201
        # byebug
        # user = User.new(user_params)
        # if user.valid? && params[:password] == params[:password_confirmation]
        #   user.save!
        #   session[:user_id] = user.id
        #   render json: user, status: :created
        # else
        #   render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        # end
      end
    
      def show
        if session[:user_id]
          user = User.find_by(session[:user_id])
          render json: user
        else
          render json: { error: "Not authorized" }, status: 401
        end
      end
    
      private
    
      def user_params
        params.permit(:username, :password, :password_confirmation, :password_digest, :image_url, :bio)
      end


    def render_unprocessible_entity(invalid)
        render json: {errors: invalid.record.errors.full_messages}, status: 422
    end
end
