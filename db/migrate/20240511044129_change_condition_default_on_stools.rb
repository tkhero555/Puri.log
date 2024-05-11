class ChangeConditionDefaultOnStools < ActiveRecord::Migration[7.1]
  def change
    change_column_default :stools, :condition, from: 0, to: 1
  end
end
