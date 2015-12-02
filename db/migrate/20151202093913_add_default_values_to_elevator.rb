class AddDefaultValuesToElevator < ActiveRecord::Migration
  def change
    change_column :elevators, :current_floor, :integer, :default => 0
    change_column :elevators, :direction, :string, :default => 'UP'
  end
end
