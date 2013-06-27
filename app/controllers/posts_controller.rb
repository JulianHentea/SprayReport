class PostsController < ApplicationController
  before_filter :authenticate
  before_filter :authenticate_user, :only => [:index, :edit, :update, :destroy]
  
  
  def new
   @post = Post.new
   @title = "New story"
  end
  
  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comment.post_id = @post.id
  end
    
  
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to root_url, :flash => { :success => "post created!" }
    else
      @feed_items = []
      render 'root_url'
    end
  end
  
  
  def edit
    @post = Post.find(params[:id])
    @title = "Edit Story"
  end

  def update
    if @post.update_attributes(post_params)
      redirect_to  edit_user_path(current_user), :flash => { :success => "Story updated." }
    else
      @title = "Update Story"
      render 'edit'
    end
  end
  
  def destroy
    @post.destroy
    redirect_to root_url, :flash => { :success => "Post deleted!"}
  end 

  private
    
    def authenticate_user
      @post = Post.find(params[:id])
      redirect_to root_url unless current_user?(@post.user)
    end
    
    private
    def post_params
      params.require(:post).permit(:title, :content, :tag_list)
    end
end

