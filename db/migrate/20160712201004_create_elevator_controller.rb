class CreateElevatorController < ActiveRecord::Migration
  def change
    create_table :elevator_controllers do |t|
      t.integer :floors, :null => false
      t.integer :elevator_count, :null => false
      t.integer :last_used_elevator
      t.timestamps null: false
    end
  end
end
