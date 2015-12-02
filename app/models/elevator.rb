class Elevator < ActiveRecord::Base

  has_many :elevator_requested_floors

  UP = 'UP'
  DOWN = 'DOWN'
  DIRECTIONS = [UP, DOWN]

  def arriveAtFloor(floor)
    self.current_floor = floor
    ElevatorRequestedFloor.destroy_all(floor: floor)
  end

  def move
    requestedFloor = ElevatorRequestedFloor.order(created_at: :asc).first
    if requestedFloor.blank?
      goingTo = self.current_floor
    else
      goingTo = requestedFloor.floor
    end

    if self.current_floor == goingTo
      self.direction = goingTo == 0 ? UP : DOWN
    else
      self.direction = self.current_floor > goingTo ? DOWN : UP
    end
  end

  def requestDown(floor)
    goToFloor floor
  end

  def requestUp(floor)
    goToFloor floor
  end

  def goToFloor(floor)
    unless floor == self.current_floor
      ElevatorRequestedFloor.create(floor: floor, elevator_id: self.id)
    end
  end

  def requestedFloors
    self.elevator_requested_floors.all().map { |r| r.floor }
  end
end
