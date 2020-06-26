class CommentsController < ApplicationController
  before_action :set_post

  def create
    @comment = @post.comments.build(comment_params)
    if @comment.save 
      redirect_to_response(t('posts.messages.post_created'), post_path(@post)) 
    else 
      redirect_back_response(t('posts.messages.post_not_updated'), false)
    end 
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    redirect_to post_path(@post)
  end

  private 

  def comment_params
    params.require(:comment).permit(:name, :comment)
  end

  def set_post
    @post = Post.find(params[:post_id])
  end
end
