class AddElevatorControllerToElevator < ActiveRecord::Migration
  def change
    add_reference :elevators, :elevator_controller, index: true, foreign_key: true
  end
end
