class TagsController < ApplicationController
  
  # def show
  #   @tag = Tag.find_by_name(tag_params) || Tag.find_by_id(tag_params)
  # end
  # 
  
   def index
     @tags = Tag.all
   end
   
   def show
     @tag = Tag.find_by_name(params[:id]) || Tag.find_by_id(params[:id])
   end
  
  private
  
  def tag_params
     params.require(:tag).permit(:name, :tag_list)
   end
end

