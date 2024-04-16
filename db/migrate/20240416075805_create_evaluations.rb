class CreateEvaluations < ActiveRecord::Migration[7.1]
  def change
    create_table :evaluations do |t|
      t.integer :score, null: false, default: 0
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :meal, index: true, foreign_key: true
      t.datetime :eated_at
      t.timestamps
    end
  end
end
