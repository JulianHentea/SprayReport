class PostsController < ApplicationController
  before_filter :authenticate
  before_filter :authenticate_user, :only => :destroy
  
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to root_url, :flash => { :success => "post created!" }
    else
      @feed_items = []
      render 'pages/home'
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
      params.require(:post).permit(:content)
    end
end