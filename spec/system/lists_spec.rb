# frozen_string_literal: true

require 'rails_helper'

describe 'ユーザーログインと新規投稿のテスト' do

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
      visit new_user_session_path
    end
    context '表示の確認' do
      it 'new_user_registration_pathが"root/user/sign_up"であるか' do
        expect(current_path).to have_content('/user/sign_up')
      end

    end
    context '登録処理のテスト' do
      it '登録後のリダイレクト先は正しいか' do
        fill_in 'user[name]', with: Faker::Lorem.characters(number:10)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: Faker::Lorem.characters(number:10)
        click_button 'Sign up'
        expect(page).to have_current_path user_path(user)
      end
    end
  end
  describe "ユーザーログイン画面(new_user_session_path)のテスト" do
    before do
      visit new_user_session_path
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
        fill_in 'user[name]', with: Faker::Lorem.characters(number:10)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: Faker::Lorem.characters(number:10)
        click_button 'Sign up'
        expect(page).to have_current_path user_path(user)
      end
    end
  end
end