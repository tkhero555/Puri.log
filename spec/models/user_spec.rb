require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }
  describe 'devise関連のチェック' do
    it "メールアドレスとパスワードが有効であること" do
      expect(user).to be_valid
    end

    it "メールアドレスがない場合は無効であること" do
      user.email = nil
      expect(user).to_not be_valid
    end

    it "パスワードがない場合は無効であること" do
      user.password = nil
      expect(user).to_not be_valid
    end

    it "ゲストユーザーが作成できること" do
      guest_user = User.guest
      expect(guest_user).to be_valid
      expect(guest_user.email).to eq("guest@example.com")
    end
  end

  describe 'after_initialize :set_defaults, if: :new_record?の動作確認' do
    it '新規作成されたユーザーのnotifications_enabledの初期値がfalseになっていること' do
      expect(user.notifications_enabled).to be false
    end
  end
end
