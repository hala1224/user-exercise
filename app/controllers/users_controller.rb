class UsersController < ApplicationController

 get '/show' do
  redirect_if_not_logged_in
  @user = current_user
  @exercises = @user.exercises
  erb :'/users/show'
 end

 get '/users' do
      redirect_if_not_logged_in
      @users = User.all
      erb :'/users/index'
 end

 get '/users/:slug' do
    redirect_if_not_logged_in
     @user = User.find_by_slug(params[:slug])
     @exercises = @user.exercises
     erb :"/users/show"
 end


end
