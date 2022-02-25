# frozen_string_literal: true

require 'rails_helper'

describe '新規登録とログイン、ユーザー情報編集のテスト' do
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

  describe "ユーザー登録画面(new_user_registration_path)のテスト" do
    before do
      visit new_user_registration_path
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
        @user = FactoryBot.build(:user)
        fill_in 'user[name]', with: @user.name
        fill_in 'user[email]', with: @user.email
        fill_in 'user[password]', with: @user.password
        fill_in 'user[password_confirmation]', with: @user.password
        click_button 'Sign up'
        expect(page).to have_current_path user_path(User.last.id.to_s)
      end
    end
  end

  describe "ユーザーログイン画面(new_user_session_path)のテスト" do
    before do
      visit new_user_session_path
      @user = create(:user)
    end

    context '表示の確認' do
      it 'new_user_session_pathが"root/user/sign_in"であるか' do
        expect(current_path).to have_content('/user/sign_in')
      end
      it '新規登録ボタンが表示されているか' do
        expect(page).to have_button 'Log in'
      end
    end

    context '登録処理のテスト' do
      it '登録後のリダイレクト先は正しいか' do
        fill_in 'user[email]', with: @user.email
        fill_in 'user[password]', with: @user.password
        click_button 'Log in'
        expect(page).to have_current_path user_path(User.last.id.to_s)
      end
    end
  end

  describe "ユーザー編集画面(edit_user_path)のテスト" do
    before do
      @user = create(:user, introduction: "test")
      sign_in @user
      visit edit_user_path(@user)
    end

    context '編集処理のテスト' do
      it '編集前のユーザー情報がフォームに表示(セット)されている' do
        expect(page).to have_field 'user[name]', with: @user.name
        expect(page).to have_field 'user[email]', with: @user.email
        expect(page).to have_field 'user[introduction]', with: "test"
      end
      it '保存ボタンが表示される' do
        expect(page).to have_button 'Edit Profile'
      end
    end

    context '更新処理に関するテスト' do
      it '更新後のリダイレクト先は正しいか' do
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[introduction]', with: Faker::Lorem.characters(number: 50)
        click_button 'Edit Profile'
        expect(page).to have_current_path user_path(@user)
      end
    end
  end
end
