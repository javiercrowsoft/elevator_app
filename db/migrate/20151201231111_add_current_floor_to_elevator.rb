class AddCurrentFloorToElevator < ActiveRecord::Migration
  def change
    add_column :elevators, :current_floor, :integer
  end
end
