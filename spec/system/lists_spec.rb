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

    context 'お題箱への新規投稿ができない' do
      it 'お題箱の新規投稿リンクがない' do
        expect(page).to_not have_link "Post"
      end
    end
    context 'お題箱の閲覧ができる' do
      it 'お題箱の一覧画面リンクがある' do
        expect(page).to have_link "お題箱"
      end
      it '一覧画面では保存済みのリクエストが表示されている' do
        click_link "お題箱"
        expect(page).to have_content @post_request.comment
      end
    end
  end

  describe "お題箱(募集中)のテスト" do
    before do
      @user1 = create(:user)
      @user2 = create(:user, is_open_to_requests: true)
      @relationship1 = create(:relationship, user_id: @user1.id, follow_id: @user2.id)
      @post_request1 = create(:post_request, user_id: @user1.id, host_id: @user2.id)
      sign_in @user1
      visit user_path(@user2)
    end

    context 'お題箱への新規投稿ができる' do
      it 'お題箱の新規投稿リンクがある' do
        expect(page).to have_link "Post"
      end
      it 'お題箱の新規投稿画面に送信ボタンがある' do
        visit new_user_post_request_path(@user2)
        expect(page).to have_button "送信"
      end
      it '新規投稿リンクから投稿すると、リダイレクト先がお題箱一覧画面になる' do
        click_link "Post"
        @post_request2 = FactoryBot.build(:post_request)
        fill_in 'post_request[comment]', with: @post_request2.comment
        click_button "送信"
        expect(page).to have_current_path user_post_requests_path(@user2)
        expect(page).to have_content @post_request1.comment
        expect(page).to have_content @post_request2.comment
      end
    end

    context 'お題箱の閲覧ができる' do
      it 'お題箱の一覧画面リンクがある' do
        expect(page).to have_link "お題箱"
      end
      it '一覧画面では保存済みのリクエストが表示されている' do
        click_link "お題箱"
        expect(page).to have_content @post_request1.comment
      end
    end

    context 'リクエストの削除ができるが、返信はできない' do
      it 'リクエスト詳細画面に削除リンクがある' do
        visit user_post_request_path(@user2, @post_request1)
        expect(page).to have_link "Destroy"
      end
      it 'リクエスト詳細画面に返信リンクがない' do
        visit user_post_request_path(@user2, @post_request1)
        expect(page).to_not have_button "返信"
      end
    end
  end

  describe "非フォローはお題箱にアクセスできないことのテスト" do
    before do
      @user1 = create(:user)
      @user2 = create(:user, is_open_to_requests: true)
      sign_in @user1
      visit user_path(@user2)
    end

    context 'お題箱への新規投稿ができない' do
      it 'お題箱の新規投稿リンクがない' do
        expect(page).to_not have_link "Post"
      end
    end
    context 'お題箱の閲覧ができない' do
      it 'お題箱の一覧画面リンクがない' do
        expect(page).to_not have_link "お題箱"
      end
    end
  end


  describe "お題箱(ホスト側)のテスト" do
    before do
      @user1 = create(:user)
      @user2 = create(:user, is_open_to_requests: true)
      @relationship1 = create(:relationship, user_id: @user1.id, follow_id: @user2.id)
      @post_request1 = create(:post_request, user_id: @user1.id, host_id: @user2.id)
      @post_request2 = create(:post_request, user_id: @user1.id, host_id: @user2.id, is_annonymous: true)
      sign_in @user2
      visit user_post_request_path(@user2, @post_request1)
    end

    context 'リクエストの一覧画面と詳細画面は互いに行き来できる' do
      it 'お題箱にはリクエストの詳細画面リンクがある' do
        visit user_post_requests_path(@user2)
        expect(page).to have_link "Show"
      end
      it 'リクエスト詳細画面にはお題箱の一覧画面リンクがある' do
        expect(page).to have_link "Request Box"
      end
    end

    context 'リクエストに返信ができるが、削除はできない' do
      it 'お題箱の詳細画面には返信ボタンがある' do
        expect(page).to have_button "返信"
      end
      it 'フォームに記入し、返信を押すと、返信が表示され、その後返信を削除すると再度フォームが表示される' do
        @host_comment = Faker::Lorem.characters(number: 50)
        fill_in 'post_request[host_comment]', with: @host_comment
        click_button "返信"
        expect(page).to have_content @host_comment
        expect(page).to have_button "返信を削除"
        click_button "返信を削除"
        expect(page).to have_field 'post_request[host_comment]', with: ''
      end
      it 'リクエスト詳細画面に削除リンクがない' do
        visit user_post_request_path(@user2, @post_request1)
        expect(page).to_not have_link "Destroy"
      end
    end

    context 'お題箱の匿名投稿が実現できている' do
      it 'リクエスト詳細画面で、「匿名さん」と表示されている' do
        visit user_post_request_path(@user2, @post_request2)
        expect(page).to have_content "匿名さん"
      end
    end

    context 'リクエストを創作メモにコピーすることができる' do
      it 'リクエスト詳細画面で、「創作メモに追加」と表示されている' do
        expect(page).to have_button "創作メモに追加"
      end
      it '通常のリクエストを創作メモに追加しても、リクエストした人の名前が表示される' do
        visit user_post_request_path(@user2, @post_request1)
        click_button "創作メモに追加"
        visit user_creator_notes_path(@user2)
        expect(page).to have_content @post_request1.user.name
        expect(page).to have_content @post_request1.comment
      end
      it '匿名リクエストを創作メモに追加しても、匿名性が維持される' do
        visit user_post_request_path(@user2, @post_request2)
        click_button "創作メモに追加"
        visit user_creator_notes_path(@user2)
        expect(page).to have_content "匿名さん"
        expect(page).to have_content @post_request2.comment
      end
    end
  end

  describe "創作メモ(ホスト側)のテスト" do
    before do
      @user1 = create(:user)
      @creator_note1 = create(:creator_note, user_id: @user1.id, requester_id: @user1.id)
      sign_in @user1
      visit user_creator_notes_path(@user1)
    end

    context '創作メモ閲覧のテスト' do
      it '創作メモ登録ボタンがある' do
        expect(page).to have_link "＋"
      end
      it '一覧画面が正しく表示できている' do
        expect(page).to have_content @creator_note1.comment
      end
      it '一覧画面から詳細画面に遷移できる' do
        expect(page).to have_link "Show"
        click_link "Show"
        expect(page).to have_current_path user_creator_note_path(@user1, @creator_note1)
      end
      it '詳細画面から一覧画面に遷移できる' do
        visit user_creator_note_path(@user1, @creator_note1)
        expect(page).to have_link "Creator Notes"
        click_link "Creator Notes"
        expect(page).to have_current_path user_creator_notes_path(@user1)
      end
      it '詳細画面に編集リンクがある' do
        visit user_creator_note_path(@user1, @creator_note1)
        expect(page).to have_link "Edit"
      end
      it '詳細画面に削除リンクがある' do
        visit user_creator_note_path(@user1, @creator_note1)
        expect(page).to have_link "Destroy"
      end
      it '創作メモ登録ボタンから新規創作メモを投稿でき、登録後一覧画面に遷移する' do
        click_link "＋"
        @creator_note2 = FactoryBot.build(:creator_note)
        fill_in 'creator_note[comment]', with: @creator_note2.comment
        expect(page).to have_button "送信"
        click_button "送信"
        expect(page).to have_current_path user_creator_notes_path(@user1)
        expect(page).to have_content @creator_note1.comment
        expect(page).to have_content @creator_note2.comment
      end
    end
  end

  describe "創作メモ(公開・他人閲覧)のテスト" do
    before do
      @user1 = create(:user)
      @user2 = create(:user)
      @relationship = create(:relationship, user_id: @user1.id, follow_id: @user2.id)
      @creator_note1 = create(:creator_note, user_id: @user2.id, requester_id: @user2.id)
      @creator_note2 = create(:creator_note, user_id: @user2.id, requester_id: @user1.id)
      sign_in @user1
      visit user_path(@user2)
    end

    context '創作メモへのアクセスができるが、新規作成はできない' do
      it '創作メモの一覧画面リンクがある' do
        expect(page).to have_link "創作メモ"
      end
      it '創作メモの新規投稿リンクがない' do
        click_link "創作メモ"
        expect(page).to_not have_link "＋"
      end
      it '詳細画面に編集リンクがない' do
        visit user_creator_note_path(@user2, @creator_note1)
        expect(page).to_not have_link "Edit"
      end
      it '詳細画面に削除リンクがない' do
        visit user_creator_note_path(@user2, @creator_note1)
        expect(page).to_not have_link "Destroy"
      end
    end

    context 'リクエスト主が自分であっても創作メモは変更できない' do
      it '詳細画面に編集リンクがない' do
        visit user_creator_note_path(@user2, @creator_note2)
        expect(page).to_not have_link "Edit"
      end
      it '詳細画面に削除リンクがない' do
        visit user_creator_note_path(@user2, @creator_note2)
        expect(page).to_not have_link "Destroy"
      end
    end
  end

  describe "創作メモ(非公開)のテスト" do
    before do
      @user1 = create(:user)
      @user2 = create(:user, creator_note_is_private: true)
      @relationship = create(:relationship, user_id: @user1.id, follow_id: @user2.id)
      sign_in @user1
      visit user_path(@user2)
    end

    context '創作メモへのアクセスができない' do
      it 'お題箱の新規投稿リンクがない' do
        expect(page).to_not have_link "創作メモ"
      end
    end
  end
end

describe 'ユーザー報告と管理者のテスト' do
  describe '管理者ログインのテスト' do
    before do
      @admin = create(:admin)
      visit new_admin_session_path
    end

    context '管理者ログインの確認' do
      it 'ログインができるかどうか' do
        fill_in 'admin[email]', with: @admin.email
        fill_in 'admin[password]', with: @admin.password
        expect(page).to have_button "Log in"
        click_button "Log in"
        expect(page).to have_current_path admin_users_path
      end
    end
  end

  describe '報告のテスト' do
    before do
      @user1 = create(:user)
      @user2 = create(:user)
      @admin = create(:admin)
      sign_in @user1
      visit user_path(@user2)
    end

    context '表示の確認' do
      it '報告リンクが表示されているか' do
        expect(page).to have_link "報告"
      end
    end

    context '報告の新規登録の確認' do
      it '報告が表示されているか' do
        click_link "報告"
        @report = FactoryBot.build(:report)
        fill_in 'report[comment]', with: @report.comment
        expect(page).to have_button "送信"
        click_button "送信"
        sign_out @user1
        sign_in @admin
        visit admin_users_path
        expect(page).to have_content @user2.name
        expect(@user2.recieved_reports.count).to eq 1
        expect(page).to have_link "Show"
        click_link "Show"
        expect(page).to have_content @report.comment
      end
    end
  end

  describe '管理者の制裁行動のテスト' do
    before do
      @user1 = create(:user)
      @user2 = create(:user)
      @admin = create(:admin)
      @report1 = create(:report, offender_id: @user1.id, user_id: @user2.id)
      @post1 = create(:post, user_id: @user1.id)
      @post2 = create(:post, user_id: @user1.id)
      @post3 = create(:post, user_id: @user2.id)
      @comment = create(:comment, user_id: @user1.id, post_id: @post3.id)
      @tweet = create(:tweet, user_id: @user1.id)
      sign_in @admin
      visit admin_user_path(@user1)
    end

    context '表示の確認' do
      it '報告ユーザー一覧リンクが表示されているか' do
        expect(page).to have_link "ユーザー一覧"
      end
      it '投稿一覧リンクが表示されているか' do
        expect(page).to have_link "投稿一覧"
      end
    end

    context '投稿全削除の確認' do
      it '投稿全削除ボタンが存在しているか' do
        expect(page).to have_link "投稿全削除"
      end
      it '投稿全削除ボタンを押すと全ての作品が消えるか？' do
        click_link "投稿全削除"
        expect(@user1.posts.count).to eq 0
      end
    end

    context 'コメント全削除の確認' do
      it 'コメント全削除ボタンが存在しているか' do
        expect(page).to have_link "コメント全削除"
      end
      it 'コメント全削除ボタンを押すと全てのコメントが消えるか？' do
        click_link "コメント全削除"
        expect(@user1.comments.count).to eq 0
      end
    end

    context 'ツイート全削除の確認' do
      it 'ツイート全削除ボタンが存在しているか' do
        expect(page).to have_link "ツイート全削除"
      end
      it 'ツイート全削除ボタンを押すと全てのツイートが消えるか？' do
        click_link "ツイート全削除"
        expect(@user1.tweets.count).to eq 0
      end
    end

    context 'レポート処理の確認' do
      it '処理済にしたレポートはリセットボタンを押せば消え、未処理のレポートは消えないか？' do
        @report2 = create(:report, offender_id: @user1.id, user_id: @user2.id, is_finished: true)
        expect(page).to have_link "未処理"
        expect(page).to have_content "処理済"
        expect(page).to have_link "処理済報告リセット"
        click_link "処理済報告リセット"
        expect(@user1.recieved_reports.count).to eq 1
        expect(page).to have_content @report1.comment
        expect(page).to_not have_content @report2.comment
      end
    end

    context '投稿各削除の確認' do
      it '投稿全削除ボタンが存在しているか' do
        visit admin_user_posts_path(@user1)
        expect(page).to have_link ""
      end
      it '投稿全削除ボタンを押すと全ての作品が消えるか？' do
        click_link "投稿全削除"
        expect(@user1.posts.count).to eq 0
      end
    end
  end
end

describe '検索機能のテスト' do
  describe '作品検索のテスト' do
    before do

    end

    context '管理者ログインの確認' do
      it 'ログインができるかどうか' do
      end
    end
  end
end