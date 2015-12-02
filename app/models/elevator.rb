class Elevator < ActiveRecord::Base

  has_many :elevator_requested_floors

  UP = 'UP'
  DOWN = 'DOWN'
  DIRECTIONS = [UP, DOWN]

  validates :floors, :numericality => true, :presence => true
  validates_exclusion_of :floors, :in => 0..0, :message => "can't be zero"

  def arrive_at_floor(floor)
    self.current_floor = floor
    self.elevator_requested_floors.where(floor: floor).destroy_all
    self.save!
  end

  def close_door
    requestedFloor = self.elevator_requested_floors.order(created_at: :asc).first
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
    self.save!
  end

  def request_down(floor)
    go_to_floor floor
  end

  def request_up(floor)
    go_to_floor floor
  end

  def go_to_floor(floor)
    floor = floor.to_i
    if floor != self.current_floor and floor < self.floors
      ElevatorRequestedFloor.create(floor: floor, elevator_id: self.id)
    end
  end

  def work
    unless self.requested_floors.empty?
      floor = self.direction == UP ? self.current_floor + 1 : self.current_floor - 1
      self.arrive_at_floor(floor)
      self.close_door
    end
  end

  def requested_floors
    self.elevator_requested_floors.order(created_at: :asc).map { |r| r.floor }
  end
end
