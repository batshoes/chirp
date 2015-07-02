class AddUserId < ActiveRecord::Migration
  def change
    add_column(:users,:user_id,:integer)
    add_column(:profiles,:user_id,:integer) 
  end
end
