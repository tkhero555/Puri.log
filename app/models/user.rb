class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[line]
  has_many :eatings, dependent: :destroy
  has_many :meals, dependent: :destroy
  has_many :stools, dependent: :destroy
  after_initialize :set_defaults, if: :new_record?

  def social_profile(provider)
    social_profiles.select { |sp| sp.provider == provider.to_s }.first
  end

  def set_values(omniauth)
    return if provider.to_s != omniauth["provider"].to_s || uid != omniauth["uid"]
    credentials = omniauth["credentials"]
    info = omniauth["info"]

    access_token = credentials["refresh_token"]
    access_secret = credentials["secret"]
    credentials = credentials.to_json
    name = info["name"]
  end

  def set_values_by_raw_info(raw_info)
    self.raw_info = raw_info.to_json
    self.save!
  end

  def self.guest
    find_or_create_by!(email: "guest@example.com") do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストユーザー"
    end
  end

  def set_defaults
    self.notifications_enabled ||= false
  end

  def set_instance_meal_log_days
    meal_log_days_record = 0
    meal_start_day = Time.zone.now.beginning_of_day
    meal_end_day = Time.zone.now.end_of_day

    while eatings.where(created_at: meal_start_day..meal_end_day).exists?
      meal_log_days_record += 1
      meal_start_day -= 1.day
      meal_end_day -= 1.day
    end

    meal_log_days_record
  end

  def set_instance_stool_log_days
    stool_log_days_record = 0
    stool_start_day = Time.zone.now.beginning_of_day
    stool_end_day = Time.zone.now.end_of_day

    while stools.where(created_at: stool_start_day..stool_end_day).exists?
      stool_log_days_record += 1
      stool_start_day -= 1.day
      stool_end_day -= 1.day
    end

    stool_log_days_record
  end

  # Userモデルに関連する定数の設定
  # 記録済みテストユーザーid
  RECORDED_TEST_USER_ID = 2
end
