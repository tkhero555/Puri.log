require 'rails_helper'

RSpec.describe "MealLogs", type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
    visit user_path
  end

  it '食事記録フォームの動作が正常であることを確認する' do
    # マイページに遷移
    visit user_path

    # 食事記録フォームに食事名入力
    fill_in 'new_meal_name', with: 'Sample Meal'

    # 食事記録フォームで日付と時刻を選択
    fill_in 'meal_created_at', with: '002024-04-01T12:00'

    # 食事記録フォームの登録するボタンを押してmealsとeatingsのテーブルにデータが増えていることを確認
    expect {
      find('.meal-btn').click
    }.to change(Meal, :count).by(1)
      .and change(Eating, :count).by(1)

    # ‘食事を記録しました’フラッシュメッセージの確認
    expect(page).to have_content '食事を記録しました'

    # 遷移先画面のpath確認
    expect(current_path).to eq user_path

    # 2個目の記録
    fill_in 'new_meal_name', with: 'Sample Meal'
    fill_in 'meal_created_at', with: '002024-04-01T22:00'

    # クリックする前のテーブルのデータ数を保管
    initial_meal_count = Meal.count
    initial_eating_count = Eating.count

    # 記録ボタンをクリック
    find('.meal-btn').click

    # mealsテーブルのデータが増えてないことを確認する
    expect(Meal.count).to eq(initial_meal_count)

    # eatingsテーブルのデータが増えていることを確認する
    expect(Eating.count).to eq(initial_eating_count + 1)
  end
end
