# class Api::V1::UsersController < ApplicationController
class Api::V1::UsersController < Api::V1::BaseController
  # should use the authenticate_user! for JWT
  before_action :authenticate_user!

  # acts_as_token_authentication_handler_for User
  before_action :set_user, only: [ :show, :update, :update_password ]

  def index
    if params[:query].present?
      sql_query = " \
        email ILIKE :query \
        OR first_name ILIKE :query \
        OR last_name ILIKE :query \
        OR user_company ILIKE :query \
        OR user_fitness_level ILIKE :query \
      "
      @users = policy_scope(User.where(sql_query, query: "%#{params[:query]}%"))
    else
      @users = policy_scope(User)
    end
  end

  def show
    # @program_trackers = @user.program_trackers
    # @program_trackers.each do |program_tracker|
    #   @daily_workout_trackers = program_tracker.daily_workout_trackers.sort { |a, b| a.id <=> b.id }
      # @daily_workout_trackers.each do |dwt|
      #   @exercise_trackers = dwt.exercise_trackers.sort { |a, b| a.id <=> b.id }
      #   dwt.exercise_trackers << @exercise_trackers
      # end
    # end
  end




  # def edit
  #   @user = current_user
  # end

  def update_password
    if @user.update(user_params)
      # Sign in the user by passing validation in case their password changed
      bypass_sign_in(@user)
      render :show
    else
      render "edit"
    end
  end

  def update
    if @user.update(user_params)
      render :show
    else
      render_error
    end
  end

  def forgot_password
    email = params[:user][:email]
    @user = User.find_by(email: email)
    @user.send_reset_password_instructions
    if @user.send_reset_password_instructions
      reset_password_token = @user.reset_password_token
      @user.reset_password_token = reset_password_token[0, 6]
      @user.save!
      authorize @user
    else
      render_error
    end
  end

  def reset_password
    token = params[:user][:reset_password_token]
    @user = User.find_by(reset_password_token: token)
    new_password = params[:user][:new_password]
    new_password_confirmation = params[:user][:new_password_confirmation]
    @user.reset_password(new_password, new_password_confirmation)
    authorize @user
  end


  private

  def set_user
    @user = User.find(params[:id])
    # @user = current_user
    authorize @user
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :user_company, :user_total_calories, :user_points, :user_gender, :user_fitness_level, :photo, :email, :age, :phone_number, :user_passions, :password, :password_confirmation, :reset_password_token, :new_password, :new_password_confirmation)
  end

  def render_error
    render json: { errors: @user.errors.full_messages },
      status: :unprocessable_entity
  end
end
