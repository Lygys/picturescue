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
        expect(page).to_not have_link 'Destroy'
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
        expect(page).to_not have_link 'Delete'
      end
    end
  end
end

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
        expect(page).to_not have_content @user1.name
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
        expect(page).to_not have_content @user1.name
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
        expect(page).to_not have_content @user1.name
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
        expect(page).to_not have_content @user2.name
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
        expect(page).to_not have_content @user1.name
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
        expect(page).to_not have_content @tweet2.tweet
      end
    end
  end
end

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

describe 'お題箱とクリエイターノートのテスト' do
  describe "お題箱(募集停止中)のテスト" do
    before do
      @user1 = create(:user)
      @user2 = create(:user)
      @relationship1 = create(:relationship, user_id: @user1.id, follow_id: @user2.id)
      @post_request = create(:post_request, user_id: @user1.id, host_id: @user2.id)
      sign_in @user1
      visit user_path(@user2)
    end

    context 'お題箱への新規登録ができない' do
      it 'ブックマークがカウントされている' do
        expect(page).to_not have_link "お題箱"
      end
      it 'リンクからも入れない' do
        visit new_user_post_request_path(@user2)
        expect(page).to have_current_path user_path(@user1)
      end
    end
    context 'お題箱の閲覧は可能' do
      it 'ブックマークしたユーザーが表示されている' do
        visit user_post_requests_path(@user2)
        expect(page).to have_content @post_request.comment
      end
    end
  end
end