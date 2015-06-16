class AddScoreToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :score, :string
  end
end
