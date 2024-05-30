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
        when "登録済の食事"
          make_logged_meals(event)

        when "排便の記録"
          make_stool_button_message
          
        when "0", "1", "2"
          make_stool_log(event)

        when "おすすめの食事"
          make_recommend_meals(event)

        when "避けるべき食事"
          make_avert_meals(event)

        when "使用説明"
          make_explain

        # 食事メニューの記録を行う
        else
          make_meal_log(event)
        end
      end
    end
  end

  def make_logged_meals(event)
    set_user(event)
    meal_log_count = Eating.where(user_id: @user_id).group(:meal_id).count
    my_meals = Meal.where(user_id: @user_id)
    logged_meals = ""
    if my_meals.empty?
      logged_meals = "まだ食事が登録されていません"
    else
      my_meals.each do |my_meal|
        my_meal_id = my_meal.id
        logged_meals << "#{my_meal.meal_name} : #{meal_log_count[my_meal_id]}回\n"
      end
    end
    message = {
                type: "text",
                text: "食事名 : 記録回数\n#{logged_meals}"
              }
    message = achievement(@user, message)
  end

  def make_stool_button_message
    message = LineBot::Messages::UnkoMessage.new.button_message
  end

  def make_stool_log(event)
    set_user(event)
    stool_log = event.message["text"].to_i
    stool = Stool.new(condition: stool_log, user_id: @user_id)
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
    end
    eatings = Eating.where(created_at: 50.hours.ago..20.hours.ago).where(user_id: @user_id)
    stool_log_reply_message = "排便の記録が完了しました。\n\n\n【今記録した便の元となっている可能性がある食事一覧】\n\n食事名：日時\n"
    eatings.each do |eating|
      meal = Meal.find(eating.meal_id)
      unless meal.update(score: meal.score + score_change)
        stool_log_reply_message = "排便の記録に失敗しました。やり直してください。"
        break
      end
      stool_log_reply_message << "#{meal.meal_name}：#{meal.created_at.strftime("%-m-%d %H:%M")}\n"
    end
    message = {
                type: "text",
                text: stool_log_reply_message
              }
    message = achievement(@user, message)
  end

  def make_recommend_meals(event)
    set_user(event)
    recommend_meals = Meal.where('score >= ?', 3).where(user_id: @user_id)
    if recommend_meals.empty?
      recommend_meals = Meal.where('score >= ?', 1).where(user_id: @user_id)
      if recommend_meals.empty?
        recommend_meal = "おすすめの食事はありません"
      else
        recommend_meal = recommend_meals.map { |meal| meal.meal_name }.join("\n")
      end
    else
      recommend_meal = recommend_meals.map { |meal| meal.meal_name }.join("\n")
    end
    message = {
                type: "text",
                text: recommend_meal
              }
    message = achievement(@user, message)
  end

  def make_avert_meals(event)
    set_user(event)
    avert_meals = Meal.where('score <= ?', -3).where(user_id: @user_id)
    if avert_meals.empty?
      avert_meals = Meal.where('score <= ?', -1).where(user_id: @user_id)
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
    message = achievement(@user, message)
  end

  def make_explain
    message = {
                type: "text",
                text: "① **LINE連携ログインの確認**

- このLINEBOTは、サイトでのLINE連携ログインが完了していることが前提条件です。
- まだの方は、サイトにアクセスしてログインを実施してください。

② **登録済の食事**

- 今までに記録したことのある、食事名の一覧が確認できます。

③ **食事の記録**

- 食事名をメッセージで送信すると、その時刻に食べたものとして記録されます。

④ **排便の記録**

- 排便の記録ボタンを押すと、3択の選択肢ボタンが送られてきます（[0: 良い, 1: 普通, 2: 悪い]）。
- 自分の便の状態を3段階で判断して、該当するボタンをクリックしてください。クリックした状態と時刻で記録されます。

⑤ **おすすめの食事・避けるべき食事**

- それぞれのボタンをクリックすると、あなたと相性の良い食事、悪い食事が送られてきます。
- まだ判定ができていない場合は、データが足りていないので、記録を継続してから再度試してください。"
    }
  end

  def make_meal_log(event)
    set_user(event)
    # 入力されたテキストを受け取り、mealsテーブルにそれが無ければ新規に登録する
    meal_log = event.message["text"]
    meal = Meal.find_by(meal_name: meal_log, user_id: @user_id)
    if meal.present?
      meal_id = meal.id
    else
      meal = Meal.new(meal_name: meal_log, user_id: @user_id)
      meal.save
      meal_id = meal.id
    end
    # evaluationテーブルにデータを保存する。評価値であるscoreのデフォルトは0
    # saveの成否に応じてユーザーへの返信内容を設定する
    eating = Eating.new(user_id: @user_id, meal_id: meal_id)
    if eating.save
      meal_log_reply_message = "食事の記録が完了しました。"
    else
      meal_log_reply_message = "食事の記録に失敗しました。やり直してください。"
    end
    message = {
                type: "text",
                text: meal_log_reply_message
              }
    message = achievement(@user, message)
  end

  def set_user(event)
    @user = User.find_by(uid: event['source']['userId'])
    @user_id = @user.id
  end

  # ユーザーに通知する実績情報を作成する
  def achievement(user, message)
    user_id = user.id
    #my_scoreの判定
    eating_count = Eating.where(user_id: user_id).count
    stool_count = Stool.where(user_id: user_id).count
    my_score = eating_count + stool_count
    # meal_log_days_recordの判定
    meal_log_days_record = 0
    meal_date = Date.today
    while Eating.where(user_id: user_id).where("DATE(created_at) = ?", meal_date).exists?
      meal_log_days_record += 1
      meal_date = meal_date.prev_day
    end
    # continuation_daysの判定
    date_registered = user.created_at.to_date
    today = DateTime.now.to_date
    continuation_days = (today - date_registered).to_i
    # first_meal second_meal third_meal
    my_meal_counts = Eating.where(user_id: user_id).group(:meal_id).count.sort_by{|key, val| -val}
    first_meal = Meal.find(my_meal_counts[0][0]).meal_name
    first_meal_count = my_meal_counts[0][1]
    second_meal = Meal.find(my_meal_counts[1][0]).meal_name
    second_meal_count = my_meal_counts[1][1]
    third_meal = Meal.find(my_meal_counts[2][0]) .meal_name
    third_meal_count = my_meal_counts[2][1]
    # 実績の返信内容を作成する
    achievement_message = "【現在の実績】\n・スコア：#{my_score}ポイント\n・#{meal_log_days_record}日連続記録達成中！(食事)\n・アプリを始めてから#{continuation_days}日経過\n\n【記録回数Top3の食事名】\n1.#{first_meal}：#{first_meal_count}回\n2.#{second_meal}：#{second_meal_count}回\n3.#{third_meal}：#{third_meal_count}回"
    achievement = [
                message,
                {
                  type: "text",
                  text: achievement_message  # ここに追加したいメッセージの内容を書く
                }
              ]
  end
end
