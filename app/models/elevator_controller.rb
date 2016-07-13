class ElevatorController < ActiveRecord::Base

  has_many :elevators

  validates :floors, :numericality => true, :presence => true
  validates :elevator_count, :numericality => true, :presence => true
  validates_exclusion_of :elevator_count, :in => 0..0, :message => "can't be zero"
  validates_exclusion_of :floors, :in => 0..0, :message => "can't be zero"

  after_save :create_elevators_if_needed

  def sorted_elevators
    self.elevators.order(created_at: :asc)
  end

  def remove_requested_floor(floor)
    self.requested_floors.where(floor: floor).destroy_all
  end

  def request_down(floor)
    go_to_floor floor
  end

  def request_up(floor)
    go_to_floor floor
  end

  def elevator_go_to_floor(floor, elevator)
    elevator = elevator.to_i
    sorted_elevators[elevator].go_to_floor(floor)
  end

  def go_to_floor(floor)
    floor = floor.to_i
    if floor < self.floors
      elevator = closest_elevator(floor)
      elevator.go_to_floor(floor)
    end
    work
  end

  def work
    self.elevators.each do |elevator|
      elevator.work
    end
  end

  def requested_floor_list
    self.requested_floors.order(created_at: :asc).map { |r| r.floor }
  end

  def create_elevators_if_needed
    for i in 1..self.elevator_count - self.elevators.count
      Elevator.create(number: i, floors: self.floors, elevator_controller_id: self.id)
    end
  end

  def closest_elevator(floor)
    min_distance = self.floors * 2
    best_elevator = nil
    self.elevators.each do |elevator|

      if floor == elevator.current_floor
        best_elevator = elevator
        break
      elsif floor > elevator.current_floor
        if [Elevator::UP, Elevator::UNDEFINED].include? elevator.direction
          d = floor - elevator.current_floor
        else
          d = floor + elevator.current_floor
        end
      else
        if [Elevator::DOWN, Elevator::UNDEFINED].include? elevator.direction
          d = elevator.current_floor - floor
        else
          d = (self.floors - floor) + (self.floors - elevator.current_floor)
        end
      end
      if d < min_distance
        best_elevator = elevator
        min_distance = d
      end
    end

    self.last_used_elevator = best_elevator.number
    save!

    best_elevator
  end
end