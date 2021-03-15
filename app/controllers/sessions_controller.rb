class SessionsController < ApplicationController
  def new
    if current_user.present?
      redirect_to root_path
    end
  end
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      log_in user
      flash.clear
      render json: user
    else
      flash[:danger] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end
  def destroy
    log_out
    redirect_to root_url
  end
end
