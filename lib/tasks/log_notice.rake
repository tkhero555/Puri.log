namespace :log_notice do
  desc "24時間記録が無いユーザーにlineメッセージを送信するタスク"
  task not_log_user_notice: :environment do
    current_time = Time.now
    users = User.all
    users.each do |user|
      if user.notifications_enabled
        last_eating = user.eatings.order(created_at: :desc).limit(1).first
        last_stool = user.stools.order(created_at: :desc).limit(1).first
        if last_eating.nil? || last_stool.nil?
          break
        elsif current_time - last_eating.created_at >= 24 * 60 * 60 || current_time - last_stool.created_at >= 24 * 60 * 60
          message = {
              type: 'text',
              text: "前回の記録から24時間が経過しました。\n忘れてしまう前に食事と排便を記録しましょう。"
          }
          client = Line::Bot::Client.new { |config|
              config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
              config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
          }
          client.push_message(user.uid, message)
        end
      end
    end
  end
end