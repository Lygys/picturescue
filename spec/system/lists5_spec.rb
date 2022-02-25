# frozen_string_literal: true

require 'rails_helper'

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
        expect(page).not_to have_link "Post"
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
        expect(page).not_to have_button "返信"
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
        expect(page).not_to have_link "Post"
      end
    end

    context 'お題箱の閲覧ができない' do
      it 'お題箱の一覧画面リンクがない' do
        expect(page).not_to have_link "お題箱"
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
        expect(page).not_to have_link "Destroy"
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
        expect(page).not_to have_link "＋"
      end
      it '詳細画面に編集リンクがない' do
        visit user_creator_note_path(@user2, @creator_note1)
        expect(page).not_to have_link "Edit"
      end
      it '詳細画面に削除リンクがない' do
        visit user_creator_note_path(@user2, @creator_note1)
        expect(page).not_to have_link "Destroy"
      end
    end

    context 'リクエスト主が自分であっても創作メモは変更できない' do
      it '詳細画面に編集リンクがない' do
        visit user_creator_note_path(@user2, @creator_note2)
        expect(page).not_to have_link "Edit"
      end
      it '詳細画面に削除リンクがない' do
        visit user_creator_note_path(@user2, @creator_note2)
        expect(page).not_to have_link "Destroy"
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
        expect(page).not_to have_link "創作メモ"
      end
    end
  end
end
