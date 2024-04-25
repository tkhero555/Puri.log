class RemoveScoreFromEvaluations < ActiveRecord::Migration[7.1]
  def change
    remove_column :evaluations, :score, :integer
  end
end
