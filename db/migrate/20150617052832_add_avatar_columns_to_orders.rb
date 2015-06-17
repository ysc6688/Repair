class AddAvatarColumnsToOrders < ActiveRecord::Migration
  def change
      add_attachment :orders, :avatar
  end
end
