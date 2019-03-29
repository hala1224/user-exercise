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
   if !redirect_if_not_logged_in
     @user = User.find_by_slug(params[:slug])
     @exercises = @user.exercises
     erb :"/users/show"
   else
     redirect '/login'
   end
 end


end
