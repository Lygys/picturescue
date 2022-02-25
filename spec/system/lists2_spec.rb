# frozen_string_literal: true

require 'rails_helper'

describe '新規投稿、コメントとツイートのテスト' do
  describe "新規投稿画面(new_post_path)のテスト" do
    before do
      @user = create(:user)
      sign_in @user
      visit new_post_path
    end

    context '表示の確認' do
      it 'new_post_pathが"root/posts/new"であるか' do
        expect(current_path).to have_content('/posts/new')
      end
      it '新規投稿ボタンが表示されているか' do
        expect(page).to have_button 'Create Post'
      end
    end

    context '投稿処理のテスト' do
      it '投稿後のリダイレクト先は正しいか' do
        @post = FactoryBot.build(:post)
        fill_in 'post[title]', with: @post.title
        fill_in 'post[body]', with: @post.body
        click_button 'Create Post'
        expect(page).to have_current_path post_path(Post.last.id.to_s)
      end
    end
  end

  describe '詳細画面のテスト' do
    before do
      @user = create(:user)
      @post = create(:post, user_id: @user.id)
      sign_in @user
      visit post_path(@post)
    end

    context '表示の確認' do
      it '削除リンクが存在しているか' do
        expect(page).to have_link 'Delete'
      end
      it '編集リンクが存在しているか' do
        expect(page).to have_link 'Edit'
      end
    end

    context 'リンクの遷移先の確認' do
      it '編集の遷移先は編集画面か' do
        click_link 'Edit'
        expect(page).to have_current_path edit_post_path(@post)
      end
    end
  end

  describe 'ユーザー詳細画面のテスト' do
    before do
      @user = create(:user)
      @post = create(:post, user_id: @user.id)
      sign_in @user
      visit user_path(@user)
    end

    context '表示の確認' do
      it '投稿されたものが表示されているか' do
        expect(page).to have_content @post.title
        expect(page).to have_link @post.title
      end
    end
  end

  describe '編集画面のテスト' do
    before do
      @user = create(:user)
      @post = create(:post, user_id: @user.id)
      sign_in @user
      visit edit_post_path(@post)
    end

    context '表示の確認' do
      it '編集前のタイトルと本文がフォームに表示(セット)されている' do
        expect(page).to have_field 'post[title]', with: @post.title
        expect(page).to have_field 'post[body]', with: @post.body
      end
      it '保存ボタンが表示される' do
        expect(page).to have_button 'Update Post'
      end
    end

    context '更新処理に関するテスト' do
      it '更新後のリダイレクト先は正しいか' do
        fill_in 'post[title]', with: Faker::Lorem.characters(number: 5)
        fill_in 'post[body]', with: Faker::Lorem.characters(number: 20)
        click_button 'Update Post'
        expect(page).to have_current_path post_path(@post)
      end
    end
  end

  # コメント登録は非同期なので、現状テストコードを実装できない

  describe 'コメント（自作）閲覧のテスト' do
    before do
      @user = create(:user)
      @post = create(:post, user_id: @user.id)
      @comment = create(:comment, user_id: @user.id, post_id: @post.id)
      sign_in @user
      visit post_path(@post)
    end

    context 'コメントに関するテスト' do
      it 'コメント内容が表示される' do
        expect(page).to have_content @comment.comment
      end
      it '削除ボタンが表示される' do
        expect(page).to have_link 'Destroy'
      end
    end
  end

  describe 'コメント（他人）閲覧のテスト' do
    before do
      @user1 = create(:user)
      @user2 = create(:user)
      @post = create(:post, user_id: @user2.id)
      @comment = create(:comment, user_id: @user1.id, post_id: @post.id)
      sign_in @user2
      visit post_path(@post)
    end

    context 'コメントに関するテスト' do
      it 'コメント内容が表示される' do
        expect(page).to have_content @comment.comment
      end
      it '削除ボタンが表示されない' do
        expect(page).not_to have_link 'Destroy'
      end
    end
  end

  describe 'ツイートのテスト' do
    before do
      @user = create(:user)
      sign_in @user
      visit tweets_path
    end

    context 'ツイート投稿に関するテスト' do
      it 'ツイートボタンが表示される' do
        expect(page).to have_button 'Tweet'
      end
      it '投稿後のリダイレクト先は正しいか' do
        @tweet = FactoryBot.build(:tweet)
        fill_in 'tweet[tweet]', with: @tweet.tweet
        click_button 'Tweet'
        expect(page).to have_current_path tweets_path
      end
    end

    context 'ツイート投稿に関するテスト' do
      it 'ツイートボタンが表示される' do
        expect(page).to have_button 'Tweet'
      end
      it '投稿後のリダイレクト先は正しいか' do
        @tweet = FactoryBot.build(:tweet)
        fill_in 'tweet[tweet]', with: @tweet.tweet
        click_button 'Tweet'
        expect(page).to have_current_path tweets_path
      end
    end
  end

  describe 'ツイート（自作）閲覧のテスト' do
    before do
      @user = create(:user)
      @tweet = create(:tweet, user_id: @user.id)
      sign_in @user
      visit tweet_path(@tweet)
    end

    context 'ツイートに関するテスト' do
      it 'ツイート内容が表示される' do
        expect(page).to have_content @tweet.tweet
      end
      it '削除ボタンが表示される' do
        expect(page).to have_link 'Delete'
      end
    end
  end

  describe 'コメント（他人）閲覧のテスト' do
    before do
      @user1 = create(:user)
      @user2 = create(:user)
      @tweet = create(:tweet, user_id: @user1.id)
      sign_in @user2
      visit tweet_path(@tweet)
    end

    context 'コメントに関するテスト' do
      it 'コメント内容が表示される' do
        expect(page).to have_content @tweet.tweet
      end
      it '削除ボタンが表示されない' do
        expect(page).not_to have_link 'Delete'
      end
    end
  end
end
