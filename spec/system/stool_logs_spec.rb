require 'rails_helper'

RSpec.describe "StoolLogs", type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
    # マイページに遷移
    visit user_path
  end

  it '状態「良い」で排便を記録した時の動作を確認する' do
    # 変動元の食事記録を作成
    fill_in 'new_meal_name', with: 'Sample Meal'
    fill_in 'meal_created_at', with: '002024-04-01T12:00'
    find('.meal-btn').click
    meal = Meal.find_by(meal_name: 'Sample Meal')

    # 変動対象の食事のscoreを0に初期化
    meal.update(score: 0)

    # 排便の状態を選択
    select '0.良い', from: 'condition'

    # 排便の日時を選択
    fill_in 'created_at', with: '002024-04-02T12:00'
    
    # 初期のstoolsテーブルのカウントを保存
    initial_stool_count = Stool.count

    # 記録ボタンを押す
    find('.stool-btn').click

    # stoolsテーブルのデータが増えていることを確認
    expect(Stool.count).to eq(initial_stool_count + 1)

    # mealsテーブルの特定のデータのscoreカラムの値が増えていることを確認
    meal.reload
    expect(meal.score).to be > 0

    # フラッシュメッセージの確認
    expect(page).to have_content '排便を記録しました'

    # 遷移先画面のpathを確認
    expect(current_path).to eq(user_path)
  end

  it '状態「普通」で排便を記録した時の動作を確認する' do
    # 変動元の食事記録を作成
    fill_in 'new_meal_name', with: 'Sample Meal'
    fill_in 'meal_created_at', with: '002024-04-01T12:00'
    find('.meal-btn').click
    meal = Meal.find_by(meal_name: 'Sample Meal')

    # 変動対象の食事のscoreを0に初期化
    meal.update(score: 0)

    # 排便の状態を選択
    select '1.普通', from: 'condition'

    # 排便の日時を選択
    fill_in 'created_at', with: '002024-04-02T12:00'
    
    # 初期のstoolsテーブルのカウントを保存
    initial_stool_count = Stool.count

    # 記録ボタンを押す
    find('.stool-btn').click

    # stoolsテーブルのデータが増えていることを確認
    expect(Stool.count).to eq(initial_stool_count + 1)

    # mealsテーブルの特定のデータのscoreカラムの値が増えていないことを確認
    meal.reload
    expect(meal.score).to eq(0)

    # フラッシュメッセージの確認
    expect(page).to have_content '排便を記録しました'

    # 遷移先画面のpathを確認
    expect(current_path).to eq(user_path)
  end

  it '状態「悪い」で排便を記録した時の動作を確認する' do
    # 変動元の食事記録を作成
    fill_in 'new_meal_name', with: 'Sample Meal'
    fill_in 'meal_created_at', with: '002024-04-01T12:00'
    find('.meal-btn').click
    meal = Meal.find_by(meal_name: 'Sample Meal')

    # 変動対象の食事のscoreを0に初期化
    meal.update(score: 0)

    # 排便の状態を選択
    select '2.悪い', from: 'condition'

    # 排便の日時を選択
    fill_in 'created_at', with: '002024-04-02T12:00'
    
    # 初期のstoolsテーブルのカウントを保存
    initial_stool_count = Stool.count

    # 記録ボタンを押す
    find('.stool-btn').click

    # stoolsテーブルのデータが増えていることを確認
    expect(Stool.count).to eq(initial_stool_count + 1)

    # mealsテーブルの特定のデータのscoreカラムの値が増えていることを確認
    meal.reload
    expect(meal.score).to be < 0

    # フラッシュメッセージの確認
    expect(page).to have_content '排便を記録しました'

    # 遷移先画面のpathを確認
    expect(current_path).to eq(user_path)
  end
end
