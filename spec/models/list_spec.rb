# frozen_string_literal: true

require 'rails_helper'

describe 'モデルのテスト' do
  describe 'ユーザーのテスト' do
    it "有効なユーザー内容の場合は保存されるか" do
      expect(FactoryBot.build(:user)).to be_valid
    end
  end
  describe '投稿のテスト' do
    it "有効な投稿内容の場合は保存されるか" do
      user = create(:user)
      expect(FactoryBot.build(:post, user_id: user.id)).to be_valid
    end
    context "空白のバリデーションチェック" do
      it "titleが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
        post = Post.new(title: '', body: 'hoge')
        expect(post).to be_invalid
        expect(post.errors[:title]).to include("can't be blank")
      end
      it "bodyが空白の場合にバリデーションチェックされ空白のエラーメッセージが返ってきているか" do
        post = Post.new(title: 'hoge', body: '')
        expect(post).to be_invalid
        expect(post.errors[:body]).to include("can't be blank")
      end
    end
  end
  describe 'コメントのテスト' do
    it "有効なコメント内容の場合は保存されるか" do
      user = create(:user)
      post = create(:post, user_id: user.id)
      expect(FactoryBot.build(:comment, user_id: user.id, post_id: post.id)).to be_valid
    end
  end
  describe 'ツイートのテスト' do
    it "有効なツイート内容の場合は保存されるか" do
      user = create(:user)
      expect(FactoryBot.build(:tweet, user_id: user.id)).to be_valid
    end
  end
  describe '創作メモのテスト' do
    it "有効な創作メモト内容の場合は保存されるか" do
      user = create(:user)
      expect(FactoryBot.build(:creator_note, user_id: user.id, requester_id: user.id)).to be_valid
    end
  end
end