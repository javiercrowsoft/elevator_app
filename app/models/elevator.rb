class Elevator < ActiveRecord::Base

  has_many :elevator_requested_floors
  belongs_to :elevator_controller

  UP = 'UP'
  DOWN = 'DOWN'
  UNDEFINED = 'UNDEFINED'
  DIRECTIONS = [UP, DOWN, UNDEFINED]

  validates :number, :numericality => true, :presence => true
  validates :floors, :numericality => true, :presence => true
  validates_exclusion_of :number, :in => 0..0, :message => "can't be zero"
  validates_exclusion_of :floors, :in => 0..0, :message => "can't be zero"

  def arrive_at_floor(floor)
    self.current_floor = floor
    self.elevator_requested_floors.where(floor: floor).destroy_all
    self.save!
  end

  def update_direction
    self.direction = get_direction
    self.save!
  end

  def close_door
    update_direction
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
    update_direction
  end

  def get_direction
    requestedFloor = self.elevator_requested_floors.order(created_at: :asc).first

    if requestedFloor.blank?
      goingTo = self.current_floor
    else
      goingTo = requestedFloor.floor
    end

    direction = UNDEFINED

    if self.current_floor == goingTo
      if goingTo == 0
        direction = UP
      elsif goingTo == self.floors-1
        direction = DOWN
      end
    else
      direction = self.current_floor > goingTo ? DOWN : UP
    end

    direction
  end

  def work
    unless self.requested_floors.empty?
      floor = self.current_floor

      direction = get_direction
      if direction == UP
        floor += 1
      elsif direction == DOWN
        floor -= 1
      end

      self.arrive_at_floor(floor)
      self.close_door
    end
  end

  def requested_floors
    self.elevator_requested_floors.order(created_at: :asc).map { |r| r.floor }
  end
end
