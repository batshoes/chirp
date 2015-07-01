class RenameUsers < ActiveRecord::Migration
  def change
    rename_table(:user, :users)
    rename_table(:profile, :profiles)
  end
end
