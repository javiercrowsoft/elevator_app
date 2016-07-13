require 'test_helper'

class ElevatorTest < ActiveSupport::TestCase

  test "should change direction" do
    elevator = Elevator.create(number:1, floors: 7) # from 0 to 6
    assert_equal Elevator::UP, elevator.direction, "A just created elevator should have direction eq UP"
    elevator.go_to_floor 4 # someone gets into the elevator and wants to go to floor 4
    elevator.close_door
    assert_equal Elevator::UP, elevator.direction, "An elevator going from 0 to 4 should have direction eq UP"
    elevator.arrive_at_floor 4
    elevator.request_down 1 # before anyone in the elevator can press a button someone else calls the elevator from floor 1 to go down
    elevator.close_door # elevator closes the door
    assert_equal Elevator::DOWN, elevator.direction, "An elevator without requested floors should have direction eq DOWN"
    elevator.go_to_floor 0 # someone in the elevator wants to go to floor 0
    elevator.go_to_floor 4 # someone in the elevator wants to go to floor 4
    elevator.arrive_at_floor 1 # elevator arrives to floor 1
    elevator.go_to_floor 5 # someone gets into the elevator and wants to go to floor 5. Notice it means going UP although the elevator was called from this floor to go to down
    elevator.close_door # elevator closes the door
    elevator.request_up 6
    assert_equal Elevator::DOWN, elevator.direction, "An elevator from 4 to 0 should have direction eq DOWN"
    elevator.arrive_at_floor 0
    elevator.close_door
    assert_equal Elevator::UP, elevator.direction, "The elevator should change direction to UP becasu it has arrived to floor 0"
    elevator.request_down 3 # someone calls the elevator from floor 3 to go down
    elevator.arrive_at_floor 4
    elevator.close_door # the elevator closes the door and continues its journey to floor 6
    assert_equal Elevator::UP, elevator.direction, "An elevator from 4 to 6 should have direction eq UP"
    elevator.arrive_at_floor 5
    elevator.arrive_at_floor 6
    elevator.close_door # the elevator closes the door and goes down to floor 3
    assert_equal Elevator::DOWN, elevator.direction, "An elevator from 6 to 3 should have direction eq DOWN"
    elevator.arrive_at_floor 3
    elevator.go_to_floor 4
    elevator.go_to_floor 3
    elevator.close_door # the elevator closes the door and goes down to floor 4
    assert_equal Elevator::UP, elevator.direction, "An elevator from 3 to 4 should have direction eq UP"
  end

  test "should accept a floor number" do
    elevator = Elevator.create(number:1, floors: 7) # from 0 to 6
    elevator.arrive_at_floor 4
    elevator.request_down 1
    elevator.go_to_floor 0
    elevator.go_to_floor 4
    elevator.go_to_floor 5
    elevator.go_to_floor 4
    elevator.go_to_floor 3
    assert_equal [1, 0,5,3], elevator.requested_floors
  end

  test "should move to that floor" do
    elevator = Elevator.create(number:1, floors: 7) # from 0 to 6
    elevator.arrive_at_floor 4
    assert_equal 4, elevator.current_floor
  end

  test "should mantain a list of floor numbers" do
    elevator = Elevator.create(number:1, floors: 7) # from 0 to 6
    elevator.arrive_at_floor 4
    elevator.request_down 1
    elevator.arrive_at_floor 1
    elevator.go_to_floor 0
    elevator.arrive_at_floor 0
    elevator.go_to_floor 4
    elevator.go_to_floor 5
    elevator.go_to_floor 4
    elevator.arrive_at_floor 4
    elevator.go_to_floor 3
    assert_equal [5,3], elevator.requested_floors
  end

  test "should move through the floors" do
    elevator = Elevator.create(number:1, floors: 7) # from 0 to 6
    elevator.arrive_at_floor 4
    elevator.request_down 1
    elevator.arrive_at_floor 1
    elevator.go_to_floor 0
    elevator.arrive_at_floor 0
    assert_equal 0, elevator.current_floor
    elevator.go_to_floor 4
    assert_equal 0, elevator.current_floor
    elevator.go_to_floor 5
    elevator.go_to_floor 4
    elevator.arrive_at_floor 4
    elevator.go_to_floor 3
    assert_equal 4, elevator.current_floor
  end

  test "should reverse direction when it reaches the top" do
    elevator = Elevator.create(number:1, floors: 7) # from 0 to 6
    elevator.go_to_floor 3
    elevator.go_to_floor 6
    elevator.close_door
    assert_equal Elevator::UP, elevator.direction, "An elevator from 0 to 6 should have direction eq UP"
    elevator.arrive_at_floor 3
    elevator.close_door
    assert_equal Elevator::UP, elevator.direction, "An elevator from 3 to 6 should have direction eq UP"
    elevator.arrive_at_floor 6
    elevator.close_door
    assert_equal Elevator::DOWN, elevator.direction, "When an elevator reaches top floor it must change direction to DOWN"
  end

end
