class AddDirectionToElevator < ActiveRecord::Migration
  def change
    add_column :elevators, :direction, :string
  end
end
