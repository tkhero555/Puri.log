require 'rails_helper'

RSpec.describe "MyPages", type: :system do
  describe 'マイページの表示コンテンツの動作を確認する' do
    let(:user) { create(:user) }

    before do
      # ユーザーをログインさせる
      sign_in user
      # マイページに遷移
      visit user_path(user)
    end
    it 'マイスコアcardの表示が正常であること' do
      # 初期の数字が0であることを確認
      initial_number = find('.my-score').text.to_i
      expect(initial_number).to eq(0)

      # 食事記録を増やす
      fill_in 'new_meal_name', with: 'Sample Meal'
      fill_in 'meal_created_at', with: '002024-04-01T12:00'
      find('.meal-btn').click

      # マイスコアが1増えていることを確認
      updated_number = find('.my-score').text.to_i
      expect(updated_number).to eq(initial_number + 1)
    end

    it '連続記録日数cardの表示が正常であること' do
      # 初期の表示部の2つの数字が0であることを確認
      meal_initial_number = find('.meal-log-days-record').text.to_i
      stool_initial_number = find('.stool-log-days-record').text.to_i
      expect(meal_initial_number).to eq(0)
      expect(stool_initial_number).to eq(0)

      # 時刻設定
      current_time = Time.now.iso8601
      one_month_ago = (DateTime.now << 1).iso8601
      # 食事記録を増やす
      fill_in 'new_meal_name', with: 'Sample Meal'
      fill_in 'meal_created_at', with: current_time
      find('.meal-btn').click

      fill_in 'new_meal_name', with: 'Sample Meal'
      fill_in 'meal_created_at', with: one_month_ago
      find('.meal-btn').click

      # 排便記録を増やす
      select '0.良い', from: 'condition'
      fill_in 'created_at', with: current_time
      find('.stool-btn').click

      select '0.良い', from: 'condition'
      fill_in 'created_at', with: one_month_ago
      find('.stool-btn').click

      # 2つの表示部の数字が1増えていることを確認する
      meal_updated_number = find('.meal-log-days-record').text.to_i
      stool_updated_number = find('.stool-log-days-record').text.to_i
      expect(meal_updated_number).to eq(meal_initial_number + 1)
      expect(stool_updated_number).to eq(stool_initial_number + 1)
    end

    it 'おすすめの食事cardの表示が正常であること' do
      # recommend-mealクラスのpタグの中身が何もないことを確認
      expect(find('.recommend-meal').text).to be_empty

      # scoreカラムが3のmealsテーブルのデータを作成し保存
      meal = Meal.create(meal_name: 'Recommend Meal', score: 3, user_id: user.id)

      # ページをリロードして変更を反映
      visit current_path

      # recommend-mealクラスのpタグの中身に保存したデータの名前が表示されていることを確認
      expect(find('.recommend-meal').text).to eq(meal.meal_name)
    end

    it 'おすすめの食事cardの表示が正常であること' do
      # recommend-mealクラスのpタグの中身が何もないことを確認
      expect(find('.avert-meal').text).to be_empty

      # scoreカラムが3のmealsテーブルのデータを作成し保存
      meal = Meal.create(meal_name: 'Avert Meal', score: -3, user_id: user.id)

      # ページをリロードして変更を反映
      visit current_path

      # recommend-mealクラスのpタグの中身に保存したデータの名前が表示されていることを確認
      expect(find('.avert-meal').text).to eq(meal.meal_name)
    end

    it '記録回数の実績cardの表示が正常であること' do
      # 初期の表示が0回となっていることを確認
      within('.log-count') do
        expect(find(:xpath, "//h3[.='通算']/following-sibling::p[1]").text).to eq('食事：0 回')
        expect(find(:xpath, "//h3[.='通算']/following-sibling::p[2]").text).to eq('排便：0 回')
        
        expect(find(:xpath, "//h3[.='今月']/following-sibling::p[1]").text).to eq('食事：0 回')
        expect(find(:xpath, "//h3[.='今月']/following-sibling::p[2]").text).to eq('排便：0 回')
        
        expect(find(:xpath, "//h3[.='先月']/following-sibling::p[1]").text).to eq('食事：0 回')
        expect(find(:xpath, "//h3[.='先月']/following-sibling::p[2]").text).to eq('排便：0 回')
      end

      # 時刻設定
      current_time = Time.now.iso8601
      one_month_ago = (DateTime.now << 1).iso8601

      # 今月の食事記録を増やす
      fill_in 'new_meal_name', with: 'Sample Meal'
      fill_in 'meal_created_at', with: current_time
      find('.meal-btn').click

      #先月の食事記録を増やす
      fill_in 'new_meal_name', with: 'Sample Meal'
      fill_in 'meal_created_at', with: one_month_ago
      find('.meal-btn').click

      # 今月の排便記録を増やす
      select '0.良い', from: 'condition'
      fill_in 'created_at', with: current_time
      find('.stool-btn').click

      # 先月の排便記録を増やす
      select '0.良い', from: 'condition'
      fill_in 'created_at', with: one_month_ago
      find('.stool-btn').click

      # 変化した表示を確認する
      within('.log-count') do
        expect(find(:xpath, "//h3[.='通算']/following-sibling::p[1]").text).to eq('食事：2 回')
        expect(find(:xpath, "//h3[.='通算']/following-sibling::p[2]").text).to eq('排便：2 回')
        
        expect(find(:xpath, "//h3[.='今月']/following-sibling::p[1]").text).to eq('食事：1 回')
        expect(find(:xpath, "//h3[.='今月']/following-sibling::p[2]").text).to eq('排便：1 回')
        
        expect(find(:xpath, "//h3[.='先月']/following-sibling::p[1]").text).to eq('食事：1 回')
        expect(find(:xpath, "//h3[.='先月']/following-sibling::p[2]").text).to eq('排便：1 回')
      end
    end

    it '登録済みの食事名一覧cardの表示が正常であること' do
      # @mealsが空の状態を確認する
      within('.meal-log-index') do
        expect(page).to have_selector('table.table tbody tr', count: 0)
      end

      # 記録を行う
      current_time = Time.now.iso8601
      fill_in 'new_meal_name', with: 'Sample Meal'
      fill_in 'meal_created_at', with: current_time
      find('.meal-btn').click

      # ページをリロードして新しい状態を確認する
      visit current_path

      within('.meal-log-index') do
        # 記録が追加されたことを確認する
        expect(page).to have_selector('table.table tbody tr', count: 1)
        expect(find('table.table tbody tr td', text: 'Sample Meal')).to be_present
        expect(find('table.table tbody tr td', text: '1')).to be_present
      end
    end

    it '胃腸の状況cardの表示が正常であること' do
      within('.stomach-condition') do
        # 通算の確認
        expect(find(:xpath, "//h3/strong[text()='便の状態ごとの記録回数(通算)']/following::p[1]").text).to eq('良い：0 回')
        expect(find(:xpath, "//h3/strong[text()='便の状態ごとの記録回数(通算)']/following::p[2]").text).to eq('普通：0 回')
        expect(find(:xpath, "//h3/strong[text()='便の状態ごとの記録回数(通算)']/following::p[3]").text).to eq('悪い：0 回')
    
        # 今月の確認
        expect(find(:xpath, "//h3/strong[text()='便の状態ごとの記録回数(今月)']/following::p[1]").text).to eq('良い：0 回')
        expect(find(:xpath, "//h3/strong[text()='便の状態ごとの記録回数(今月)']/following::p[2]").text).to eq('普通：0 回')
        expect(find(:xpath, "//h3/strong[text()='便の状態ごとの記録回数(今月)']/following::p[3]").text).to eq('悪い：0 回')
    
        # 先月の確認
        expect(find(:xpath, "//h3/strong[text()='便の状態ごとの記録回数(先月)']/following::p[1]").text).to eq('良い：0 回')
        expect(find(:xpath, "//h3/strong[text()='便の状態ごとの記録回数(先月)']/following::p[2]").text).to eq('普通：0 回')
        expect(find(:xpath, "//h3/strong[text()='便の状態ごとの記録回数(先月)']/following::p[3]").text).to eq('悪い：0 回')
      end

      # 時刻設定
      current_time = Time.now.iso8601
      one_month_ago = (DateTime.now << 1).iso8601

      # 3種の状態で今月と先月の排便記録を作る
      select '0.良い', from: 'condition'
      fill_in 'created_at', with: current_time
      find('.stool-btn').click

      select '0.良い', from: 'condition'
      fill_in 'created_at', with: one_month_ago
      find('.stool-btn').click

      select '1.普通', from: 'condition'
      fill_in 'created_at', with: current_time
      find('.stool-btn').click

      select '1.普通', from: 'condition'
      fill_in 'created_at', with: one_month_ago
      find('.stool-btn').click

      select '2.悪い', from: 'condition'
      fill_in 'created_at', with: current_time
      find('.stool-btn').click

      select '2.悪い', from: 'condition'
      fill_in 'created_at', with: one_month_ago
      find('.stool-btn').click

      # 変動した表示を確認する
      within('.stomach-condition') do
        # 通算の確認
        expect(find(:xpath, "//h3/strong[text()='便の状態ごとの記録回数(通算)']/following::p[1]").text).to eq('良い：2 回')
        expect(find(:xpath, "//h3/strong[text()='便の状態ごとの記録回数(通算)']/following::p[2]").text).to eq('普通：2 回')
        expect(find(:xpath, "//h3/strong[text()='便の状態ごとの記録回数(通算)']/following::p[3]").text).to eq('悪い：2 回')
    
        # 今月の確認
        expect(find(:xpath, "//h3/strong[text()='便の状態ごとの記録回数(今月)']/following::p[1]").text).to eq('良い：1 回')
        expect(find(:xpath, "//h3/strong[text()='便の状態ごとの記録回数(今月)']/following::p[2]").text).to eq('普通：1 回')
        expect(find(:xpath, "//h3/strong[text()='便の状態ごとの記録回数(今月)']/following::p[3]").text).to eq('悪い：1 回')
    
        # 先月の確認
        expect(find(:xpath, "//h3/strong[text()='便の状態ごとの記録回数(先月)']/following::p[1]").text).to eq('良い：1 回')
        expect(find(:xpath, "//h3/strong[text()='便の状態ごとの記録回数(先月)']/following::p[2]").text).to eq('普通：1 回')
        expect(find(:xpath, "//h3/strong[text()='便の状態ごとの記録回数(先月)']/following::p[3]").text).to eq('悪い：1 回')
      end
    end

    it '記録履歴一覧cardの表示が正常であること' do
      # @mealsが空の状態を確認する
      within('.log-index') do
        expect(page).to have_selector('table.table tbody tr', count: 0)
      end

      # 時刻設定
      current_time = Time.now.iso8601
      one_month_ago = (DateTime.now << 1).iso8601

      # 現在時刻の食事記録を作成
      fill_in 'new_meal_name', with: '今月のサンプル'
      fill_in 'meal_created_at', with: current_time
      find('.meal-btn').click

      # 1月前の食事記録を作成
      fill_in 'new_meal_name', with: '先月のサンプル'
      fill_in 'meal_created_at', with: one_month_ago
      find('.meal-btn').click

      # 記録が追加されたことを確認する
      within('.log-index') do
        expect(page).to have_selector('table.table tbody tr', count: 2)
        expect(find('table.table tbody tr td', text: '今月のサンプル')).to be_present
        expect(find('table.table tbody tr td', text: '先月のサンプル')).to be_present
      end

      # 古い順の並び替えボタンを押す
      
      # 先月のサンプルが先に表示されていることを確認する
  
      # 保管した値の中身を確認する

      # 新しい順の並び替えボタンを押す

      # 今月のサンプルが先に表示されていることを確認する
    end

    it 'セッティングcardが正常に動作すること' do
      # 通知変更ボタンをクリック

      # テストユーザーのnotifications_enabledが変化していることを確認する

      # 削除ボタンをクリック

      # 確認ダイアログをクリック

      # テストユーザーが消えていることを確認する
    end
  end
end
