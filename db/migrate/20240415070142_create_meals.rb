class CreateMeals < ActiveRecord::Migration[7.1]
  def change
    create_table :meals do |t|
      t.string :meal_name
      t.belongs_to :user
      t.timestamps
    end
  end
end
