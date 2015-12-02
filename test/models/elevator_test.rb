require 'test_helper'

class ElevatorTest < ActiveSupport::TestCase

  test "should change direction" do
    elevator = Elevator.create
    assert_equal Elevator::UP, elevator.direction, "A just created elevator should has direction eq UP"
    elevator.goToFloor 4 # someone gets in the elevator and wants to go floor 4
    elevator.move
    assert_equal Elevator::UP, elevator.direction, "An elevator going from 0 to 4 should has direction eq UP"
    elevator.arriveAtFloor 4
    elevator.requestDown 1 # before anyone in the elevator can press a button someone else calls the elevator from floor 1 to going down
    elevator.move # elevator closes door
    assert_equal Elevator::DOWN, elevator.direction, "An elevator without requested floors should has direction eq DOWN"
    elevator.goToFloor 0 # someone in the elevator wants to go floor 0
    elevator.goToFloor 4 # someone in the elevator wants to go floor 4
    elevator.arriveAtFloor 1 # elevator arrives to floor 1
    elevator.goToFloor 5 # someone gets in the elevator and wants to go floor 5. notice it means going UP despite the elevator was called from this floor to going down
    elevator.move # elevator closes door
    elevator.requestUp 6
    assert_equal Elevator::DOWN, elevator.direction, "An elevator from 4 to 0 should has direction eq DOWN"
    elevator.arriveAtFloor 0
    elevator.move
    assert_equal Elevator::UP, elevator.direction, "The elevator should change direction to UP becasu it has arrived to floor 0"
    elevator.requestDown 3 # someone calls the elevator from floor 3 to going down
    elevator.arriveAtFloor 4
    elevator.move # the elevator closes door and continues its journey to floor 6
    assert_equal Elevator::UP, elevator.direction, "An elevator from 4 to 6 should has direction eq UP"
    elevator.arriveAtFloor 5
    elevator.arriveAtFloor 6
    elevator.move # the elevator closes door and goes down to floor 3
    assert_equal Elevator::DOWN, elevator.direction, "An elevator from 6 to 3 should has direction eq DOWN"
    elevator.arriveAtFloor 3
    elevator.goToFloor 4
    elevator.goToFloor 3
    elevator.move # the elevator closes door and goes down to floor 4
    assert_equal Elevator::UP, elevator.direction, "An elevator from 3 to 4 should has direction eq UP"
  end

  test "should accept a floor number" do
    elevator = Elevator.create
    elevator.arriveAtFloor 4
    elevator.requestDown 1
    elevator.goToFloor 0
    elevator.goToFloor 4
    elevator.goToFloor 5
    elevator.goToFloor 4
    elevator.goToFloor 3
    assert_equal [1, 0,5,3], elevator.requestedFloors
  end

  test "should move to that floor" do
    elevator = Elevator.create
    elevator.arriveAtFloor 4
    assert_equal 4, elevator.current_floor
  end

  test "should mantain a list of floor numbers" do
    elevator = Elevator.create
    elevator.arriveAtFloor 4
    elevator.requestDown 1
    elevator.arriveAtFloor 1
    elevator.goToFloor 0
    elevator.arriveAtFloor 0
    elevator.goToFloor 4
    elevator.goToFloor 5
    elevator.goToFloor 4
    elevator.arriveAtFloor 4
    elevator.goToFloor 3
    assert_equal [5,3], elevator.requestedFloors
  end

  test "should move through the floors" do
    elevator = Elevator.create
    elevator.arriveAtFloor 4
    elevator.requestDown 1
    elevator.arriveAtFloor 1
    elevator.goToFloor 0
    elevator.arriveAtFloor 0
    assert_equal 0, elevator.current_floor
    elevator.goToFloor 4
    assert_equal 0, elevator.current_floor
    elevator.goToFloor 5
    elevator.goToFloor 4
    elevator.arriveAtFloor 4
    elevator.goToFloor 3
    assert_equal 4, elevator.current_floor
  end

  test "should reverse direction when it reaches the top" do
    assert false
  end

end
