class AddFloorsToElevator < ActiveRecord::Migration
  def change
    add_column :elevators, :floors, :integer
  end
end
