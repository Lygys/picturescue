# frozen_string_literal: true

require 'rails_helper'

# ブックマークとファボの登録は非同期で現状テストコードが書けない
describe 'ブックマークとファボのテスト' do
  describe "ブックマークのテスト" do
    before do
      @user1 = create(:user)
      @user2 = create(:user)
      @post = create(:post, user_id: @user1.id)
      @bookmark = create(:bookmark, user_id: @user2.id, post_id: @post.id)
      sign_in @user1
    end

    context '表示の確認' do
      it 'ブックマークがカウントされている' do
        expect(@post.bookmarks.count).to eq 1
      end
      it 'リンクが表示されている' do
        visit post_path(@post)
        expect(page).to have_link @post.bookmarks.count
      end
    end

    context 'ブックマークユーザーページの表示の確認' do
      it 'ブックマークしたユーザーが表示されている' do
        visit bookmarking_users_post_path(@post)
        expect(page).to have_content @user2.name
      end
    end

    context 'ユーザーブックマークページの表示の確認' do
      it 'ユーザーのブックマークが表示されている' do
        visit bookmarks_user_path(@user2)
        expect(page).to have_content @post.title
      end
    end
  end

  describe "ファボのテスト" do
    before do
      @user1 = create(:user)
      @user2 = create(:user)
      @tweet = create(:tweet, user_id: @user1.id)
      @favorite = create(:favorite, user_id: @user2.id, tweet_id: @tweet.id)
      sign_in @user1
    end

    context '表示の確認' do
      it 'ファボがカウントされている' do
        expect(@tweet.favorites.count).to eq 1
      end
      it 'リンクが表示されている' do
        visit tweet_path(@tweet)
        expect(page).to have_link @tweet.favorites.count
      end
    end

    context 'ファボユーザーページの表示の確認' do
      it 'ファボしたユーザーが表示されている' do
        visit favoriting_users_tweet_path(@tweet)
        expect(page).to have_content @user2.name
      end
    end

    context 'ユーザーファボページの表示の確認' do
      it 'ユーザーのファボしたツイートが表示されている' do
        visit favorite_tweets_user_path(@user2)
        expect(page).to have_content @tweet.tweet
      end
    end
  end
end
