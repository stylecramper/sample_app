class UsersController < ApplicationController
  
  before_filter :authenticate, :only => [:edit, :update, :index, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => :destroy
  
  def index
    @title = 'All users'
    @users = User.paginate(:page => params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
    @microposts = @user.microposts.paginate(:page => params[:page])
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
  end
  
  def update
    if @user.update_attributes(params[:user])
      #it worked
      redirect_to @user, :flash => { :success => 'Profile updated.' }
    else
      #it failed
      @title = 'Edit user'
      render 'edit'
    end
  end
  
  def destroy
    @user.destroy
    redirect_to users_path, :flash => {:success =>  'User destroyed'}
    
  end
  
  def following
    @title = 'Following'
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end
  
  def followers
    @title = 'Followers'
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end
  
  private
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      @user = User.find(params[:id])
      redirect_to(root_path) if (!current_user.admin? || current_user?(@user))
    end

end
