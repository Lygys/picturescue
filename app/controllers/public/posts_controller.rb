class Public::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    tag_list = params[:post][:tag_name].split
    if @post.save
      @post.save_tags(tag_list)
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
  end

  def update
    tag_list = params[:post][:tag_name].split
    if @post.update(post_params)
      @post.save_tags(tag_list)
      redirect_to post_path(@post), notice: "編集が完了しました"
    else
      render "edit"
    end
  end

  def destroy
    if @post.destroy
      redirect_to user_path(current_user), notice: "投稿を削除しました"
    else
      render "show"
    end
  end

  def bookmarking_users
    @post = Post.find(params[:id])
    @users = @post.bookmarking_users.page(params[:page]).per(20)
  end

  private

  def post_params
    params.require(:post).permit(:title, :post_image, :body)
  end

  def ensure_correct_user
    @post = Post.find(params[:id])
    unless @post.user == current_user
      redirect_to user_path(current_user)
    end
  end
end
