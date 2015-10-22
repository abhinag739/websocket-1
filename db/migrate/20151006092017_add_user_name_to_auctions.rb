class AddUserNameToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :user_name, :string
  end
end
