class CommentsController < ApplicationController
  before_filter :authenticate,     :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user,     :only => [:edit, :update]
  before_filter :admin_user,       :only => [:destroy]
  before_filter :verify_email,     :only => [:was_email_verified]
  
  
  
  def index
   
  end

  def show
    
  end

  def new
  
  end
  
  def create
    @comment = Comment.new(user_params)
    @comment.post_id = params[:post]
    @comment.save
    redirect_to post_path(@comment.post)
  end

  
  def edit
   
  end
  
  
  def update
    
  end
  
  def destroy
   
  end
  
  private
  
  

    def user_params
       params.require(:comment).permit(:author_name, :body)
    end

end