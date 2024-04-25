class ChangeEvaluationsToEating < ActiveRecord::Migration[7.1]
  def change
    rename_table :evaluations, :eatings
  end
end
