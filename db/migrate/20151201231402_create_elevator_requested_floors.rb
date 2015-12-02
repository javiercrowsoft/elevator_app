class CreateElevatorRequestedFloors < ActiveRecord::Migration
  def change
    create_table :elevator_requested_floors do |t|
      t.integer :floor
      t.references :elevator, index: true, foreign_key: true
      t.timestamps
    end
  end
end
