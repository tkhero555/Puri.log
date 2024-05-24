# Rails.rootを使用するために必要
require File.expand_path(File.dirname(__FILE__) + '/environment')

# cronを実行する環境変数
rails_env = ENV['RAILS_ENV'] || :development

# cronを実行する環境変数をセット
set :environment, rails_env

# cronのログの吐き出し場所
set :output, "#{Rails.root}/log/cron.log"

ENV.each { |k, v| env(k, v) }

#定期実行したい処理を記入　rakeタスクで設定したタスクを6時間ごとに実行
every 6.hours do
  rake "log_notice:not_log_user_notice"
end