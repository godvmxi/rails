class LoginController < ApplicationController

  def index
    @total_orders = Order.count
    @pending_orders = Order.count_pending
  end

  def add_user
    @user = User.new(params[:user])
    @user.save
  end

  def login
    if request.get?
      session[:user_id] = nil
      @user = User.new
    else
      @user = User.new(params[:user])
      logged_in_user = @user.try_to_login
      if logged_in_user
        session[:user_id] = logged_in_user.id
        redirect_to(:action => "index")
      else
        print "Invalid user/password combination\n"
        flash[:notice] = "Invalid user/password combination"
      end
    end
  end
  def logout
  end

  def delete_user
  end

  def list_users
  end
end
