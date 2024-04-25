class AddDefaultToScore < ActiveRecord::Migration[7.1]
  def change
    change_column_default :meals, :score, from: nil, to: 0
  end
end
