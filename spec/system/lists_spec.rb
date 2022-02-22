# frozen_string_literal: true

require 'rails_helper'

describe '新規登録と新規投稿のテスト' do
  describe 'トップ画面(root_path)のテスト' do
    before do
      visit root_path
    end
    context '表示の確認' do
      it 'root_pathがrootであるか' do
        expect(current_path).to have_content('/')
      end
      it 'トップ画面(root_path)に「ようこそ、Picturescueへ！」が表示されているか' do
        expect(page).to have_content 'ようこそ、Picturescueへ！'
      end
    end
  end
  describe "ユーザー登録画面(new_user_session_path)のテスト" do
    before do
      visit new_user_registration_path
      @user = FactoryBot.build(:user)
    end
    context '表示の確認' do
      it 'new_user_registration_pathが"root/user/sign_up"であるか' do
        expect(current_path).to have_content('/user/sign_up')
      end
      it '新規登録ボタンが表示されているか' do
        expect(page).to have_button 'Sign up'
      end
    end
    context '登録処理のテスト' do
      it '登録後のリダイレクト先は正しいか' do
        fill_in 'user[name]', with: @user.name
        fill_in 'user[email]', with: @user.email
        fill_in 'user[password]', with: @user.password
        fill_in 'user[password_confirmation]', with: @user.password
        click_button 'Sign up'
        expect(page).to have_current_path eq(user_path(@user))
      end
    end
  end
  describe "新規登録画面(new_post_path)のテスト" do
    before do
      visit new_post_path
      @post = FactoryBot.build(:post)
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
        fill_in 'post[title]', with: @post.title
        fill_in 'post[body]', with: @post.body
        click_button 'Create Post'
        expect(page).to have_current_path post_path(@post)
      end
    end
  end
  describe '詳細画面のテスト' do
    before do
      visit post_path(@post)
    end
    context '表示の確認' do
      it '削除リンクが存在しているか' do
        expect(page).to have_link 'Destroy'
      end
      it '編集リンクが存在しているか' do
        expect(page).to have_link 'Edit'
      end
    end
    context 'リンクの遷移先の確認' do
      it '編集の遷移先は編集画面か' do
        click_button 'Edit'
        expect(current_path).to edit_post_path(@post)
      end
    end
  end
  describe 'ユーザー詳細画面のテスト' do
    before do
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
      visit edit_post_path(@post)
    end
    context '表示の確認' do
      it '編集前のタイトルと本文がフォームに表示(セット)されている' do
        expect(page).to have_field 'post[title]', with: @post.title
        expect(page).to have_field 'post[body]', with: @post.body
      end
      it '保存ボタンが表示される' do
        expect(page).to have_button 'Edit Post'
      end
    end
    context '更新処理に関するテスト' do
      it '更新後のリダイレクト先は正しいか' do
        fill_in 'post[title]', with: Faker::Lorem.characters(number:5)
        fill_in 'post[body]', with: Faker::Lorem.characters(number:20)
        click_button 'Update Post'
        expect(page).to have_current_path post_path(@post)
      end
    end
  end
end
