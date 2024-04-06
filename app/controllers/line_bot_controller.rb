class LineBotController < ApplicationController

  def callback
    events.each do |event|
      client.reply_message(event['replyToken'], message(event))
    end
  end

  private

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def request_body
    request_body = request.body.read
  end

  def events
    # gemのメソッドであるparse_events_from(body)でevents配列を取得する。
    events = client.parse_events_from(request_body)
  end

  def message(event)
    # caseを使用して、eventの種類の条件をwhenで指定して、種類ごとに処理を行う。
    case event
    # eventがMessageかどうかをチェック
    when Line::Bot::Event::Message
    # ネストしてcaseを使用、eventのさらにタイプで分類
      case event.type
      # MessageType::Textかどうかをチェック
      when Line::Bot::Event::MessageType::Text
        case event.message["text"]
        when "食事の記録"
          message = {
                      type: "text",
                      text: "メッセージで食べたもののメニュー名を送ると記録されます。" +
                      "送った際の時刻に食べたものとして記録されます。" +
                      "時間指定をして記録したい場合は、サイトから実行してください。"
                    }

        when "便の記録"
          message = LineBot::Messages::UnkoMessage.new.button_message

        when "1", "2", "3"
          puts "便の記録完了確認用"
          stool_log = event.message["text"]
=begin 便の記録と、状態に応じた評価値の変動未実装 issue#21で対応予定
          Stool.create({ status: message.to_i })
=end
          message = {
                      type: "text",
                      text: "排便の記録が完了しました。" 
                    }

        when "おすすめの食事"
          puts "おすすめの食事動作確認用"
=begin データベース操作のコード 動作未確認 issue#22で対応予定
          recommend_meal = Evaluation.where('evaluation >= ?', 3).order('RANDOM()').first
          if recommend_meal.nil?
            recommend_meal = Evaluation.where('evaluation >= ?', 1).order('RANDOM()').first
            if recommend_meal.nil?
              recommend_meal = "おすすめの食事はありません"
            else
              recommend_meal = recommend_meal.name
            end
          else
            recommend_meal = recommend_meal.name
          end
=end
          recommend_meal = "おすすめの食事機能は未実装です。"
          message = {
                      type: "text",
                      text: recommend_meal
                    }

        when "避けるべき食事"
          puts "避けるべき食事動作確認用"
=begin データベース操作のコード 動作未確認 issue#22で対応予定
          avert_meal = Evaluation.where('evaluation <= ?', -3).order('RANDOM()').first
          if avert_meal.nil?
            avert_meal = Evaluation.where('evaluation <= ?', -1).order('RANDOM()').first
            if avert_meal.nil?
              avert_meal = "避けるべき食事はありません"
            else
              avert_meal = avert_meal.name
            end
          else
            avert_meal = avert_meal.name
          end
=end
          avert_meal = "避けるべき食事機能は未実装です。"
          message = {
                      type: "text",
                      text: avert_meal
                    }

        else
          meal_log = event.message["text"]
=begin
          データベースへの保管を行うコードを実装予定 issue#20で対応予定
=end
          message = {
                      type: "text",
                      text: "食事の記録が完了しました。" 
                    }
        end
      end
    end
  end
end
