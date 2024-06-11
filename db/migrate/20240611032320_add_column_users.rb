class AddColumnUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :accepted, :boolean, default: false, null:  false
  end
end
