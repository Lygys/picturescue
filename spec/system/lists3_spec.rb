# frozen_string_literal: true

require 'rails_helper'

describe 'フォロー関係とタイムラインのテスト' do
  describe "フォローリクエストのテスト" do
    before do
      @user1 = create(:user)
      @user2 = create(:user)
      sign_in @user1
      visit user_path(@user2)
    end

    context '表示の確認' do
      it 'フォローリクエストボタンが表示されているか' do
        expect(page).to have_button 'Follow Request'
      end
    end

    context 'フォローリクエストのテスト（フォロー側がキャンセルした場合）' do
      it 'フォローリクエストを送ってキャンセルするとフォローリクエストに追加されない' do
        click_button 'Follow Request'
        expect(page).to have_current_path user_path(@user2)
        expect(page).to have_button 'Remove Request'
        click_button 'Remove Request'
        sign_in @user2
        visit potential_followers_user_path(@user2)
        expect(page).not_to have_content @user1.name
        expect(@user1.potential_followings.count).to eq 0
        expect(@user1.followings.count).to eq 0
        expect(@user2.potential_followers.count).to eq 0
        expect(@user2.followers.count).to eq 0
      end
    end

    context 'フォローリクエストのテスト（フォロワー側が承認した場合）' do
      it 'フォローリクエストが来て承認するとフォロー関係が生成する' do
        click_button 'Follow Request'
        expect(page).to have_current_path user_path(@user2)
        sign_in @user2
        visit potential_followers_user_path(@user2)
        expect(page).to have_button 'Accept Request'
        click_button 'Accept Request'
        expect(page).not_to have_content @user1.name
        visit followers_user_path(@user2)
        expect(page).to have_content @user1.name
        expect(@user1.potential_followings.count).to eq 0
        expect(@user1.followings.count).to eq 1
        expect(@user2.potential_followers.count).to eq 0
        expect(@user2.followers.count).to eq 1
      end
    end

    context 'フォローリクエストのテスト（フォロワー側が拒否した場合）' do
      it 'フォローリクエストが来て拒否するとフォロー関係が生成されない' do
        click_button 'Follow Request'
        expect(page).to have_current_path user_path(@user2)
        sign_in @user2
        visit potential_followers_user_path(@user2)
        expect(page).to have_button 'Reject Request'
        click_button 'Reject Request'
        visit followers_user_path(@user2)
        expect(page).not_to have_content @user1.name
        expect(@user1.potential_followings.count).to eq 0
        expect(@user1.followings.count).to eq 0
        expect(@user2.potential_followers.count).to eq 0
        expect(@user2.followers.count).to eq 0
      end
    end
  end

  describe "リムーブのテスト" do
    before do
      @user1 = create(:user)
      @user2 = create(:user)
      @relationship = create(:relationship, user_id: @user1.id, follow_id: @user2.id)
      sign_in @user1
      visit followings_user_path(@user1)
    end

    context '表示の確認' do
      it 'リムーブボタンが表示されているか' do
        expect(page).to have_button 'Remove'
        expect(page).to have_content @user2.name
      end
    end

    context 'リムーブのテスト' do
      it 'リムーブするとフォロー一覧から消える' do
        click_button 'Remove'
        expect(page).not_to have_content @user2.name
        expect(@user1.followings.count).to eq 0
      end
    end
  end

  describe "ブロックのテスト" do
    before do
      @user1 = create(:user)
      @user2 = create(:user)
      @relationship = create(:relationship, user_id: @user1.id, follow_id: @user2.id)
      sign_in @user2
      visit followers_user_path(@user2)
    end

    context '表示の確認' do
      it 'ブロックボタンが表示されているか' do
        expect(page).to have_button 'Block'
        expect(page).to have_content @user1.name
      end
    end

    context 'フォローリクエストのテスト（撤回）' do
      it 'ブロックするとフォロワー一覧から消える' do
        click_button 'Block'
        expect(page).not_to have_content @user1.name
        expect(@user2.followers.count).to eq 0
      end
    end
  end

  # tweets_pathでは、自分のツイートとフォローユーザーのツイートの両方が存在し、tweets_user_pathでは、自分のツイートのみ存在
  describe "タイムラインのテスト" do
    before do
      @user1 = create(:user)
      @user2 = create(:user)
      @relationship = create(:relationship, user_id: @user1.id, follow_id: @user2.id)
      @tweet1 = create(:tweet, user_id: @user1.id)
      @tweet2 = create(:tweet, user_id: @user2.id)
      sign_in @user1
      visit tweets_path
    end

    context '表示の確認' do
      it '本人とフォローユーザーのツイートが表示されているか' do
        expect(page).to have_content @tweet1.tweet
        expect(page).to have_content @tweet2.tweet
      end
    end

    context 'フォローリクエストのテスト（撤回）' do
      it '本人のツイートだけが表示されているか' do
        visit tweets_user_path(@user1)
        expect(page).to have_content @tweet1.tweet
        expect(page).not_to have_content @tweet2.tweet
      end
    end
  end
end
