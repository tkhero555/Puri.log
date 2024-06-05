require 'rails_helper'

RSpec.describe "Logins", type: :system do
  describe 'ログイン動作のテスト' do
    it 'ログインボタンのurlがlineのapiを呼び出すものになっていること' do
      visit root_path
      expect(page).to have_selector('form.button_to[action="/users/auth/line"]')
      expect(page).to have_button('LINE連携ログイン')
    end
  end

  describe 'omniauthログインの動作' do
    before do
      OmniAuth.config.mock_auth[:line] = nil
      Rails.application.env_config['omniauth.auth'] = set_omniauth
      visit root_path
    end

    it 'ログインをするとユーザーが増える' do
      expect {
        all('button', text: 'LINE連携ログイン').first.click
      }.to change(User, :count).by(1)
      expect(page).to have_content 'ログインしました'
      user = User.find_by(email: 'test@example.com')
      expect(current_path).to eq user_path(user)
    end
  end
end
