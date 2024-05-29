FactoryBot.define do
  factory :user do
    email { "test@example.com" }
    password { "password" }
    password_confirmation { "password" }
    name { "Test User" }
    provider { "line" }
    uid { "123456" }
    notifications_enabled { "false" }
  end
end

