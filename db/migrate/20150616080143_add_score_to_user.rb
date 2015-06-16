class AddScoreToUser < ActiveRecord::Migration
  def change
    add_column :users, :count, :integer
    add_column :users, :score, :float
  end
end
