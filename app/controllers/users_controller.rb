class UsersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def show
    if session[:user_id].present?
      user = User.find(session[:user_id])
      render json: user.slice(:id, :username)
    else
      render json: { error: "Not authorized" }, status: :unauthorized
    end
  end


  def create
    user = User.create(user_params)
    if user.valid?
      session[:user_id] = user.id

      render json: user, status: :created
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:username, :password, :password_confirmation)
  end

  def render_not_found_response
    render json: { error: "User not found" }, status: :not_found
  end
end
