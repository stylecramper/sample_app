class UsersController < ApplicationController
  
  before_filter :authenticate, :only => [:edit, :update]
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end
  
  def new
    @title = 'Sign up'
    @user = User.new
  end
  
  def create
    # raise params[:user].inspect # create a runtime error to inspect the user params
    @user = User.new(params[:user])
    if @user.save
      # handle the save
      sign_in @user
      redirect_to @user, :flash => { :success => 'Welcome to the Sample App!' } 
    else
      @title = 'Sign up'
      render 'new'
    end
  end
  
  def edit
    @title = 'Edit user'
    @user = User.find(params[:id])
    
  end
  
  def update
    @user  = User.find(params[:id])
    if @user.update_attributes(params[:user])
      #it worked
      redirect_to @user, :flash => { :success => 'Profile updated.' }
    else
      #it failed
      @title = 'Edit user'
      render 'edit'
    end
  end
  
  def index
    
  end
  
  def destroy
    
  end
  
  private
  
    def authenticate
      deny_access unless signed_in?
    end

end
