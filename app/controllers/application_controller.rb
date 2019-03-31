require './config/environment'
require 'rack-flash'

class ApplicationController < Sinatra::Base
   use Rack::Flash

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do
    if logged_in?
      redirect '/exercises'
    else
      erb :index
    end
  end

  get "/login" do
    if logged_in?
      redirect '/exercises'
    else
      erb :"/users/login"
    end
  end

  get "/signup" do
    if logged_in?
      flash[:notice] = "You're already logged in! Redirecting..."
      redirect '/exercises'
    else
      erb :"/users/create_user"
    end
  end

  post "/signup" do
    if params[:username] == "" || params[:password] == "" || params[:email] == ""
      flash[:error] = "You have missing required fields."
      redirect '/signup'

      # checking if username is unique
      # @user = User.find_by(:username => params[:username])

    else
      @user = User.new(params)
      check = User.find_by(:username => params[:username])
      # binding.pry
      if check==nil
        @user.save
        session[:user_id] = @user.id
        flash[:notice] = "Welcome to DSN gym!"
        redirect '/exercises'
      elsif
         @user.username.downcase == check.username.downcase
         flash[:error] = "Username is taken!"
         redirect '/signup'
       end
      # end
    end
  end


  post "/login" do
    @user = User.find_by(:username => params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:success] = "Welcome, #{@user.username}!"
      redirect '/exercises'
    else
      flash[:error] = "Login failed!"
      redirect '/login'
    end
  end

  get "/logout" do
    if logged_in?
      session.clear
      redirect '/login'
    else
      session.clear
      redirect '/'
    end
  end

  helpers do

    def redirect_if_not_logged_in
     if !logged_in?
       redirect '/login'
     end
    end
    def current_user
      # binding.pry
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def logged_in?
      !!current_user
    end
  end



  end
