class Public::CommentsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.new(comment_params)
    @comment.post_id = @post.id
    if @comment.save
      render :index
    else
      render 'public/posts/show'
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = Comment.find_by(id: params[:id], post_id: params[:post_id])
    if @comment.user_id = current_user.id
      @comment.destroy
      @post = Post.find(params[:post_id])
      render :index
    else
      redirect_to user_path(current_user)
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:comment)
  end
end
