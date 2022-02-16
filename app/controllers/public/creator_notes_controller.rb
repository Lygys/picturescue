class Public::CreatorNotesController < ApplicationController
  before_action :ensure_correct_user, only: [:new, :create, :edit, :update, :destroy, :reset]

  def ensure_correct_user
    @user = User.find(params[:user_id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  def new
    @note = CreatorNote.new
  end

  def create
    @note = CreatorNote.new(creator_note_params)
    @note.user_id = current_user.id
    if @note.save
      redirect_to user_creator_notes_path(@user), notice: "創作メモを追加しました"
    else
      @user = User.find(params[:user_id])
      render 'new'
    end
  end

  def index
    @user = User.find(params[:user_id])
    @notes = @user.creator_notes.order(created_at: :desc).page(params[:page]).per(50)
  end

  def show
    @user = User.find(params[:user_id])
    @note = CreatorNote.find_by(id: params[:id], user_id: @user.id)
  end

  def edit
    @user = User.find(params[:user_id])
    @note = CreatorNote.find_by(id: params[:id], user_id: @user.id)
  end

  def update
    @user = User.find(params[:user_id])
    @note = CreatorNote.find_by(id: params[:id], user_id: @user.id)
    if @note.update(creator_note_params)
      redirect_to user_creator_note_path(@user, @note)
    else
      flash.now[:alert] = "返信メッセージを送れませんでした"
      request.referer
    end
  end


  def destroy
    @user = User.find(params[:user_id])
    @note = CreatorNote.find_by(id: params[:id], user_id: @user.id)
    if @note.destroy
      redirect_to user_creator_notes_path(@user), notice: "創作メモを削除しました"
    else
      flash.now[:alert] = "創作メモを削除できませんでした"
      request.referer
    end
  end

  def reset
    @user = User.find(params[:user_id])
    @notes = CreatorNote.where(user_id: @user.id)
    if @notes.destroy_all
      redirect_to user_creator_notes_path(@user), notice: "創作メモをリセットしました"
    else
      flash.now[:alert] = "創作メモをリセットできませんでした"
      request.referer
    end
  end


  private

  def creator_note_params
    params.require(:post_request).permit(:comment, :requester_id, :is_annonymous)
  end

end
