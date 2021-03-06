class AccountsController < ApplicationController

  def login
    case request.method
      when :post
      if session[:user] = User.authenticate(params[:user_login], params[:user_password])

        flash[:notice]  = "Login successful"
        cookies[:is_admin] = "yes"
        redirect_back_or_default :controller => "admin/general", :action => "index"
      else
        flash.now['notice']  = "Login unsuccessful"

        @login = params[:user_login]
      end
    end
  end
  
  def signup
    redirect_to :action => "login" and return unless User.count.zero? 
    
    @user = User.new(params[:user])
    
    if request.post? and @user.save
      session[:user] = User.authenticate(@user.login, params[:user][:password])
      flash[:notice]  = "Signup successful"
      redirect_to :controller => "admin/general", :action => "index"
      return
    end      
  end  
  
  def logout
    session[:user] = nil
    cookies.delete :is_admin
  end
    
  def welcome
  end
  
end
