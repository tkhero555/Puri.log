namespace :test do
  desc "wheneverの動作確認用のタスク"
  task testing: :environment do
    p "テスト成功"
  end
end
