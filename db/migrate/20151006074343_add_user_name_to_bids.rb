class AddUserNameToBids < ActiveRecord::Migration
  def change
    add_column :bids, :user_name, :string
  end
end
