class AddOrgToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :org, :string
    remove_column :orders, :type, :string
  end
end
