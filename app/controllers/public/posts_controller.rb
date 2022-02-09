class Public::PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_path(@post), notice: "投稿が完了しました"
    else
      render 'new'
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

  def index
    @all_posts = Post.all
    @posts = @all_posts.order(created_at: :desc).page(params[:page]).per(20)
  end

  def edit
    @post = Post.find(params[:id])
    redirect_to user_path(current_user) unless @post.user == current_user
  end

  def update
    @post = Post.find(params[:id])
    if @post.user_id == current_user.id
      if @post.update(post_params)
        redirect_to post_path(@post), notice: "編集が完了しました"
      else
        render "edit"
      end
    else
      redirect_to user_path(current_user)
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.user_id == current_user.id
      if @post.destroy
        redirect_to user_path(current_user), notice: "投稿を削除しました"
      else
        render "show"
      end
    else
      redirect_to user_path(current_user)
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :post_image,:body, tag_ids: [])
  end

end
