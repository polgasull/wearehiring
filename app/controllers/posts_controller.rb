class PostsController < ApplicationController

  def index
    @posts = Post.all.order("created_at DESC")
  end 

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)

    if @post.save (
      redirect_to_response(t('posts.messages.post_created'), @post) 
    else 
      redirect_to_response(t('posts.messages.post_created'), posts_path) 
    end
  end

  def show;end 

  def update
    if @post.update(post_params)
      redirect_to_response(t('posts.messages.post_updated'), @post)
    else
      redirect_back_response(t('posts.messages.post_not_updated'), false)
    end 
  end

  def edit
  end

  def destroy
    @post.destroy

    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :description, :image)
  end

end