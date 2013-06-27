class UsersController < ApplicationController
  before_filter :authenticate,     :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user,     :only => [:edit, :update]
  before_filter :admin_user,       :only => [:destroy]
  before_filter :verify_email,     :only => [:was_email_verified]
  
  
  
  def index
    @users = User.paginate(:page => params[:page], :per_page => 20)
    @title = "All users"
  end

  def show
    @user = User.find(params[:id])  
    @posts = @user.posts.paginate(:page => params[:page], :per_page => 20)
    @title = @user.name
  end
  
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page], :per_page => 20)
    render 'show_follow'
  end
  
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page], :per_page => 20)
    render 'show_follow'
  end
  
   def new
    @user = User.new
    @title = "Sign Up"
   end
  
  def create
    @user = User.new(user_params)
    @user.email_verification_token = rand(10 ** 8)
    if @user.save
      sign_in @user
      Pony.mail(
        to:      @user.email,
        subject: "Thanks for registering",
        body:    "Please click the following link to verify your email address:

#{verify_email_url(@user.id, @user.email_verification_token)}")
      
      redirect_to @user, :flash => { :success => "Welcome to the party!" }
    else
      @title = "Sign Up"
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
    @title = "Edit user"
  end
  
  def verify_email
    @user = User.find(params[:id])
    if @user != nil
      if @user.email_verification_token == params[:token]
        @user.was_email_verified = true
        @user.save!
        flash[:success] = "Email has been verified."
        sign_in @user
      else
        flash[:error] = "Wrong email verification token"
      end
      redirect_to @user
    else
      flash[:error] =  "Couldn't find user with that ID" 
      redirect_to(signup_path)
    end
  end
  
  
  def update
    if @user.update_attributes(user_params)
      redirect_to @user, :flash => { :success => "Profile updated." }
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    redirect_to users_path, :flash => { :success =>"User destroyed." } 
  end
  
  private
  
  
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
  
    def admin_user
      user = User.find(params[:id])
      redirect_to(root_path) if !current_user.admin? || current_user?(user)
    end

    def user_params
       params.require(:user).permit(:name, :email, :password,
                                      :password_confirmation, :email_verification_token, :was_email_verified)
    end

end

