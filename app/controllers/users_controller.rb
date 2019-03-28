class UsersController < ApplicationController

 get '/show' do
   if logged_in?
     @user = current_user
     @exercises = @user.exercises
     erb :"/users/show.erb/"
   else
     redirect '/login'
   end
 end

 get '/users/:slug' do
   @user = User.find_by_slug(params[:slug])
   @exercises = @user.exercises
   erb :"/users/show"
 end

 
end
