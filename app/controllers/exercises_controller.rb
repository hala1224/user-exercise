class ExercisesController < ApplicationController


  get "/exercises/new" do
    @user = current_user
    if logged_in?
      erb :"/exercises/create_exercise"
    end
    if redirect_if_not_logged_in
      redirect '/login'
    end
   end


  post "/new" do
    if logged_in? && params[:content] != ""
      @user = current_user
      # switched params[:user_id] to session for protection
      @exercise = Exercise.create(content: params["content"], user_id: session[:user_id])
      @exercise.save
      erb :"/exercises/show_exercise"
    elsif logged_in? && params[:content] == ""
      flash[:notice] = "Your class is blank!"
      redirect '/exercises/new'
    else
      flash[:notice] = "Please log in to proceed"
      redirect '/login'
    end
  end

  get "/exercises" do
    if logged_in?
      @user = current_user
      erb :"/exercises/exercises"
    end
    if redirect_if_not_logged_in
      redirect '/login'
    end
  end


  get "/exercises/:id" do
    @user = current_user
    @exercise = Exercise.find_by_id(params[:id])
    if redirect_if_not_logged_in
      redirect '/login'
    else
      erb :"/exercises/show_exercise"
    end
  end

  get "/exercises/:id/edit" do
    if logged_in?
      @exercise = Exercise.find(params[:id])
      if @exercise.user_id == session[:user_id]
        erb :"/exercises/edit_exercise"
      else
        redirect '/login'
      end
    end
    if redirect_if_not_logged_in
      redirect '/login'
    end
  end





  patch "/exercises/:id" do
    if params[:content] == ""
      flash[:notice] = "Please enter class description to proceed"
      redirect "/exercises/#{params[:id]}/edit"
    else
      @user = current_user
      @exercise = Exercise.find_by_id(params[:id])
      if logged_in? && @exercise.user_id == session[:user_id]
          @exercise = Exercise.find(params[:id])
          @exercise.update(content: params[:content])
          redirect "/exercises/#{@exercise.id}"
       else
          erb :'/exercises/error'
       end

    end
  end

  delete "/exercises/:id/delete" do
    @user = current_user
    @exercise = Exercise.find_by_id(params[:id])
    if logged_in? && @exercise.user_id == session[:user_id]
      @exercise.delete
      erb :'/exercises/delete'
    elsif !logged_in? || @exercise.user_id != session[:user_id]
      erb :'/exercises/error'
    else
      erb :'/exercises/error'
    end
  end

end
