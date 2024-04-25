class AddColumnToMeals < ActiveRecord::Migration[7.1]
  def change
    add_column :meals, :score, :integer
  end
end
