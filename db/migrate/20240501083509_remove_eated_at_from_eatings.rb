class RemoveEatedAtFromEatings < ActiveRecord::Migration[7.1]
  def change
    remove_column :eatings, :eated_at, :datetime
  end
end
