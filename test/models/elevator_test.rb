require 'test_helper'

class ElevatorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should accept a floor number" do
    elevator = Elevator.new
    elevator.arriveAtFloor 4
    elevator.requestDown 1
    elevator.goToFloor 0
    elevator.goToFloor 4
    elevator.goToFloor 5
    elevator.goToFloor 4
    elevator.goToFloor 3
    assert_equal elevator.requestedFloor, [0,5,3]
  end

  test "should change direction" do
    assert false
  end
  test "should accept a floor number" do
    assert false
  end
  test "should move to that floor" do
    assert false
  end
  test "should mantain a list of floor numbers" do
    assert false
  end
  test "should move through the floors" do
    assert false
  end
  test "should reverse direction when it reaches the top" do
    assert false
  end
end
