class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :title
      t.string :persion
      t.string :phone
      t.string :email
      t.text :text
      t.string :type
      t.string :repairman
      t.string :suggestion
      t.string :status
      t.string :comment

      t.timestamps null: false
    end
  end
end
