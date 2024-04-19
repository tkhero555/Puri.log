class CreateStools < ActiveRecord::Migration[7.1]
  def change
    create_table :stools do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :condition, default: 0, null: false
      t.timestamps
    end
  end
end
