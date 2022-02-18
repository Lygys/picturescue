class Public::CreatorNotesController < ApplicationController
  before_action :authenticate_user!
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
    @note.user_id = @user.id
    if @note.save
      if @user.id != @note.requester_id
        redirect_to request.referer, notice: "創作メモに追加しました"
      else
        redirect_to user_creator_notes_path(@user), notice: "創作メモを追加しました"
      end
    else
      @user = User.find(params[:user_id])
      render 'new'
    end
  end

  def index
    @user = User.find(params[:user_id])
    @creator_notes = CreatorNote.where(user_id: @user.id).order(created_at: :desc).page(params[:page]).per(20)
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
      redirect_to user_creator_note_path(@user, @note), notice: "創作メモを編集しました"
    else
      flash.now[:alert] = "創作メモを変更できませんでした"
      render 'edit'
    end
  end


  def destroy
    @user = User.find(params[:user_id])
    @note = CreatorNote.find_by(id: params[:id], user_id: @user.id)
    if @note.destroy
      redirect_to user_creator_notes_path(@user), notice: "創作メモを削除しました"
    else
      flash.now[:alert] = "創作メモを削除できませんでした"
      redirect_to request.referer
    end
  end

  def reset
    @user = User.find(params[:user_id])
    @notes = CreatorNote.where(user_id: @user.id)
    if @notes.destroy_all
      redirect_to user_creator_notes_path(@user), notice: "創作メモをリセットしました"
    else
      flash.now[:alert] = "創作メモをリセットできませんでした"
      redirect_to request.referer
    end
  end


  private

  def creator_note_params
    params.require(:creator_note).permit(:comment, :requester_id, :is_annonymous, :evaluation)
  end

end
