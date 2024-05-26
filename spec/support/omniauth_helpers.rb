module OmniAuthHelpers
  def set_omniauth(service = :line)
    OmniAuth.config.test_mode = true

    OmniAuth.config.mock_auth[service] = OmniAuth::AuthHash.new({
      provider: service.to_s,
      uid: '123456',
      info: {
        name: "Test User",
        email: "test@example.com",
        image: "https://test.com/test.png"
      },
      credentials: {
        token: 'mock_token',
        refresh_token: 'mock_refresh_token',
        expires_at: Time.now + 1.week
      }
    })
  end
end