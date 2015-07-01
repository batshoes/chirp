class CreateProfilesTable < ActiveRecord::Migration
  def change
    create_table :profile do |t|
      t.string :fname
      t.string :lname
      t.integer :zip_code
      t.string :occupation
    end
  end
end
