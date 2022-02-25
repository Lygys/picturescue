# frozen_string_literal: true

require 'rails_helper'

describe '検索機能のテスト' do
  describe '作品検索のテスト' do
    before do
      @user = create(:user)
      @post1 = create(:post, title: "t1", user_id: @user.id)
      @post2 = create(:post, title: "t11", user_id: @user.id)
      @tag1 = create(:tag, name: "a")
      @tag2 = create(:tag, name: "ab")
      @post_tag1 = create(:post_tag, post_id: @post1.id, tag_id: @tag1.id)
      @post_tag2 = create(:post_tag, post_id: @post2.id, tag_id: @tag2.id)
      sign_in @user
      visit search_page_path
    end

    context '作品のタイトルで完全検索' do
      it 't1で検索をかけると、@post1だけが結果に表示される' do
        fill_in "search-content", with: "t1"
        select 'Post'
        select '完全一致'
        click_button '検索'
        expect(page).to have_link @post1.title
        expect(page).not_to have_link @post2.title
      end
    end

    context '作品のタイトルで部分検索' do
      it 't1で検索をかけると、@post1と@post2がどちらも結果に表示される' do
        fill_in "search-content", with: "t1"
        select 'Post'
        select '部分一致'
        click_button '検索'
        expect(page).to have_link @post1.title
        expect(page).to have_link @post2.title
      end
    end

    context '作品のタグで完全検索' do
      it 'aで検索をかけると、@post1だけが結果に表示される' do
        fill_in "search-content", with: "a"
        select 'Tag'
        select '完全一致'
        click_button '検索'
        expect(page).to have_link @post1.title
        expect(page).not_to have_link @post2.title
      end
    end

    context '作品のタグで部分検索' do
      it 'aで検索をかけると、@post1と@post2がどちらも結果に表示される' do
        fill_in "search-content", with: "a"
        select 'Tag'
        select '部分一致'
        click_button '検索'
        expect(page).to have_link @post1.title
        expect(page).to have_link @post2.title
      end
    end
  end
end
