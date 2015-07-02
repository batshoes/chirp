class AddDefaultToProfile < ActiveRecord::Migration
  def change
  	change_column(:profiles, :fname, :string, default: "")
  	change_column(:profiles, :lname, :string, default: "")
  	change_column(:profiles, :zip_code, :integer, default: "")
  	change_column(:profiles, :occupation, :string, default: "")

  end
end

