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
        # LINEBOTを操作しているユーザーのLINEIDとusersテーブルのデータを紐づける
        user = User.find_by(uid: event['source']['userId'])
        user_id = user.id
        case event.message["text"]
        when "食事の記録"
          message = {
                      type: "text",
                      text: "食べたものの名前をメッセージしてください。\n送った時刻に食べたものとして記録されます。"
                    }

        when "排便の記録"
          message = LineBot::Messages::UnkoMessage.new.button_message

        when "0", "1", "2"
          stool_log = event.message["text"].to_i
          stool = Stool.new(condition: stool_log, user_id: user_id)
          unless stool.save
            message = {
              type: "text",
              text: "排便の記録に失敗しました。やり直してください。"
            }
            return
          end
          if stool_log == 0
            score_change = 1
          elsif stool_log == 2
            score_change = -1
          else
            score_change = 0
            stool_log_reply_message = "排便の記録が完了しました。"
          end
          if score_change == 1 || score_change == -1
            eatings = Eating.where(created_at: 50.hours.ago..20.hours.ago).where(user_id: user_id)
            eatings.each do |eating|
              meal = Meal.find(eating.meal_id)
              unless meal.update(score: meal.score + score_change)
                stool_log_reply_message = "排便の記録に失敗しました。やり直してください。"
                break
              end
            end
            stool_log_reply_message = "排便の記録が完了しました。"
          end
          message = {
                      type: "text",
                      text: stool_log_reply_message
                    }

        when "おすすめの食事"
          recommend_meals = Meal.where('score >= ?', 3).where(user_id: user_id)
          if recommend_meals.empty?
            recommend_meals = Meal.where('score >= ?', 1).where(user_id: user_id)
            if recommend_meals.empty?
              recommend_meal = "おすすめの食事はありません"
            else
              recommend_meal = recommend_meals.map { |meal| meal.meal_name }.join("\n")
            end
          else
            recommend_meal = recommend_meals.map { |meal| meal.meal_name }.join("\n")
          end
          p recommend_meals
          message = {
                      type: "text",
                      text: recommend_meal
                    }

        when "避けるべき食事"
          avert_meals = Meal.where('score <= ?', -3).where(user_id: user_id)
          if avert_meals.empty?
            avert_meals = Meal.where('score <= ?', -1).where(user_id: user_id)
            if avert_meals.empty?
              avert_meal = "避けるべき食事はありません"
            else
              avert_meal = avert_meals.map { |meal| meal.meal_name }.join("\n")
            end
          else
            avert_meal = avert_meals.map { |meal| meal.meal_name }.join("\n")
          end
          message = {
                      type: "text",
                      text: avert_meal
                    }

        when "使用説明"
          message = {
                      type: "text",
                      text: "①LINE連携ログインが完了済みか確認する\n
このLINEBOTはサイトでのLINE連携ログインが完了していることが前提条件です。\n
まだの方はサイトにアクセスボタンからログインを実施してください。\n
②食事の記録の仕方\n
食事名をメッセージで送信すると、その時刻に食べたものとして記録されます。\n
③排便の記録\n
排便の記録ボタンを押すと3択の選択肢ボタンが送られてきます[0:良い, 1:普通, 2:悪い]\n
自分の便の状態を3段階で判断して、該当するボタンをクリックしてください。
クリックした状態と時刻で記録されます。\n
④おすすめの食事・避けるべき食事\n
それぞれのボタンをクリックすると、あなたと相性の良い食事、悪い食事が送られてきます。\n
まだ判定ができていない場合は、データが足りていないので、記録を継続してから再度試してください"
                    }

        # 食事メニューの記録を行う
        else
          # 入力されたテキストを受け取り、mealsテーブルにそれが無ければ新規に登録する
          meal_log = event.message["text"]
          meal = Meal.find_by(meal_name: meal_log, user_id: user_id)
          if meal.present?
            meal_id = meal.id
          else
            meal = Meal.new(meal_name: meal_log, user_id: user_id)
            meal.save
            meal_id = meal.id
          end
          # evaluationテーブルにデータを保存する。評価値であるscoreのデフォルトは0
          # saveの成否に応じてユーザーへの返信内容を設定する
          eating = Eating.new(user_id: user_id, meal_id: meal_id)
          if eating.save
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
