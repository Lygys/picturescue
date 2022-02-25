# frozen_string_literal: true

require 'rails_helper'

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
      @offense1 = create(:offense)
      @offense2 = create(:offense)
      @offense3 = create(:offense)
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
        check @offense1.name
        check @offense2.name
        uncheck @offense3.name
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
        expect(page).to have_content @offense1.name
        expect(page).to have_content @offense2.name
        expect(page).not_to have_content @offense3.name
      end
    end
  end

  describe '管理者の制裁行動のテスト' do
    before do
      @user1 = create(:user)
      @user2 = create(:user)
      @admin = create(:admin)
      @report1 = create(:report, offender_id: @user1.id, user_id: @user2.id)
      @offense1 = create(:offense)
      @offense2 = create(:offense)
      @report_offense1 = create(:report_offense, report_id: @report1.id, offense_id: @offense1.id)
      @report_offense2 = create(:report_offense, report_id: @report1.id, offense_id: @offense2.id)
      @post1 = create(:post, user_id: @user1.id)
      @post2 = create(:post, user_id: @user1.id)
      @post3 = create(:post, user_id: @user2.id)
      @comment1 = create(:comment, user_id: @user1.id, post_id: @post3.id)
      @comment2 = create(:comment, user_id: @user2.id, post_id: @post1.id)
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
      it '報告タグの内容が複数表示されるかどうか' do
        expect(page).to have_content @offense1.name
        expect(page).to have_content @offense2.name
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

    context 'レポート処理済リンクの確認' do
      it '未処理リンクを押せば処理済みになるか？' do
        expect(page).to have_link "未処理"
        click_link "未処理"
        expect(page).to have_content "処理済"
      end
    end

    context 'レポート処理の確認' do
      it 'リセットボタンを押せば、処理済レポートは消える一方で、未処理のレポートは消えないか？' do
        @report2 = create(:report, offender_id: @user1.id, user_id: @user2.id, is_finished: true)
        expect(page).to have_link "処理済報告リセット"
        click_link "処理済報告リセット"
        expect(@user1.recieved_reports.count).to eq 1
        expect(page).to have_content @report1.comment
        expect(page).not_to have_content @report2.comment
      end
    end

    context '投稿ページの確認' do
      it 'ユーザー詳細リンクと投稿詳細リンクが存在しているか' do
        visit admin_user_posts_path(@user1)
        expect(page).to have_link "報告一覧"
        expect(page).to have_link @post1.title
        expect(page).to have_link @post2.title
      end
      it '投稿詳細ページでは本文とコメントが見られ、投稿一覧画面へのリンクが存在しているか' do
        visit admin_user_post_path(@user1, @post1)
        expect(page).to have_content @post1.body
        expect(page).to have_content @comment2.comment
        expect(page).to have_link "投稿一覧"
      end
      it '投稿一覧ページには削除リンクが存在しているか' do
        visit admin_user_posts_path(@user1)
        expect(page).to have_link "削除"
      end
    end

    context '退会の確認' do
      it '退会処理に付随してデータが消えるか？' do
        expect(page).to have_link "ブロック"
        click_link "ブロック"
        expect(@user1.posts.count).to eq 0
        expect(@user1.comments.count).to eq 0
        expect(@user1.tweets.count).to eq 0
        expect(@user1.recieved_reports.count).to eq 0
      end
      it '退会処理をすると、ユーザーがログインできなくなり、ブロックページに遷移するか？' do
        click_link "ブロック"
        sign_out @admin
        visit new_user_session_path
        fill_in 'user[email]', with: @user1.email
        fill_in 'user[password]', with: @user1.password
        click_button "Log in"
        expect(page).to have_current_path block_page_path
      end
    end
  end
end
