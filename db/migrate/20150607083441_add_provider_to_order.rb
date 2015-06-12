class AddProviderToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :provider, :string
  end
end
