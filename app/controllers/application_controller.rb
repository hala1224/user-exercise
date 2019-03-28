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
        # binding.pry
        redirect '/exercises'
       else
         flash[:error] = "Username is taken!"
         # binding.pry
         redirect '/signup'
      end
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

  # get '/users/:slug' do
  #   @user = User.find_by_slug(params[:slug])
  #   @exercises = @user.exercises
  #   erb :"/users/show"
  # end
  #
  # get "/exercises/new" do
  #   @user = current_user
  #   if logged_in?
  #     erb :"/exercises/create_exercise"
  #   else
  #     redirect '/login'
  #   end
  # end
  #
  # post "/new" do
  #   if logged_in? && params[:content] != ""
  #     @user = current_user
  #     @exercise = Exercise.create(content: params["content"], user_id: params[:user_id])
  #     @exercise.save
  #     erb :"/exercises/show_exercise"
  #   elsif logged_in? && params[:content] == ""
  #     flash[:notice] = "Your class is blank!"
  #     redirect '/exercises/new'
  #   else
  #     flash[:notice] = "Please log in to proceed"
  #     redirect '/login'
  #   end
  # end
  #
  # get "/exercises" do
  #   if logged_in?
  #     @user = current_user
  #     erb :"/exercises/exercises"
  #   else
  #     redirect '/login'
  #   end
  # end
  #
  # get "/exercises/:id" do
  #   @user = current_user
  #   @exercise = Exercise.find_by_id(params[:id])
  #   if !logged_in?
  #     redirect '/login'
  #   else
  #     erb :"/exercises/show_exercise"
  #   end
  # end
  #
  # get "/exercises/:id/edit" do
  #   if logged_in?
  #     @exercise = Exercise.find(params[:id])
  #     if @exercise.user_id == session[:user_id]
  #       # binding.pry
  #     erb :"/exercises/edit_exercise"
  #     else
  #       redirect '/login'
  #     end
  #   else
  #     redirect '/login'
  #   end
  # end
  #
  #
  #
  #
  #
  # patch "/exercises/:id" do
  #   if params[:content] == ""
  #     flash[:notice] = "Please enter class description to proceed"
  #     redirect "/exercises/#{params[:id]}/edit"
  #   else
  #     @exercise = Exercise.find(params[:id])
  #     @exercise.update(content: params[:content])
  #     redirect "/exercises/#{@exercise.id}"
  #   end
  # end
  #
  # delete "/exercises/:id/delete" do
  #   @user = current_user
  #   @exercise = Exercise.find_by_id(params[:id])
  #   if logged_in? && @exercise.user_id == session[:user_id]
  #     @exercise.delete
  #     erb :'/exercises/delete'
  #   elsif !logged_in? || @exercise.user_id != session[:user_id]
  #     erb :'/exercises/error'
  #   else
  #     erb :'/exercises/error'
  #   end
  # end


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
    def current_user
      # binding.pry
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def logged_in?
      !!current_user
    end
  end

end
