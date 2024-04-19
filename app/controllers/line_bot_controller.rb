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

        when "0", "1", "2"
          user = User.find_by(uid: event['source']['userId'])
          user_id = user.id
          stool_log = event.message["text"].to_i
          stool = Stool.new(condition: stool_log, user_id: user_id)
          if stool.save
            stool_log_reply_message = "排便の記録が完了しました。"
          else
            stool_log_reply_message = "排便の記録に失敗しました。やり直してください。"
          end
          if stool_log == 0
            evaluations = Evaluation.where(eated_at: 50.hours.ago..20.hours.ago).where(user_id: user_id)
            evaluations.each do |evaluation|
              if evaluation.update(score: evaluation.score + 1)
                stool_log_reply_message = "排便の記録が完了しました。"
              else
                stool_log_reply_message = "排便の記録に失敗しました。やり直してください。"
                break
              end
            end
          elsif stool_log == 2
            evaluations = Evaluation.where(eated_at: 50.hours.ago..20.hours.ago).where(user_id: user_id)
            evaluations.each do |evaluation|
              if evaluation.update(score: evaluation.score - 1)
                stool_log_reply_message = "排便の記録が完了しました。"
              else
                stool_log_reply_message = "排便の記録に失敗しました。やり直してください。"
                break
              end
            end
          end
          message = {
                      type: "text",
                      text: stool_log_reply_message
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
        
        # 食事メニューの記録を行う
        else
          # LINEBOTを操作しているユーザーのLINEIDとusersテーブルのデータを紐づける
          user = User.find_by(uid: event['source']['userId'])
          user_id = user.id
          # 入力されたテキストを受け取り、mealsテーブルにそれが無ければ新規に登録する
          meal_log = event.message["text"]
          meal = Meal.find_by(meal_name: meal_log)
          if meal.present?
            meal_id = meal.id
          else
            meal = Meal.new(meal_name: meal_log, user_id: user_id)
            meal.save
            meal_id = meal.id
          end
          # evaluationテーブルにデータを保存する。評価値であるscoreのデフォルトは0
          # saveの成否に応じてユーザーへの返信内容を設定する
          evaluation = Evaluation.new(user_id: user_id, meal_id: meal_id, eated_at: Time.current)
          if evaluation.save
            meal_log_reply_message = "食事の記録が完了しました。"
          else
            meal_log_reply_message = "食事の記録に失敗しました。やり直してください。"
          end
          message = {
                      type: "text",
                      text: meal_log_reply_message
                    }
        end
      end
    end
  end
end
