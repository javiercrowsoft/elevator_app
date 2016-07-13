require 'test_helper'

class ElevatorControllerTest < ActiveSupport::TestCase

  test "should create elevators" do
    elevator_controller = ElevatorController.create(floors: 7, elevator_count: 4) # from 0 to 6
    assert_equal 4, elevator_controller.elevators.count
  end

  test "should accept a floor number" do
    elevator_controller = ElevatorController.create(floors: 7, elevator_count: 4) # from 0 to 6
    elevator_controller.elevator_go_to_floor 1, 1
    elevator_controller.elevator_go_to_floor 4, 1
    elevator_controller.elevator_go_to_floor 5, 3
    elevator_controller.elevator_go_to_floor 4, 1
    elevator_controller.elevator_go_to_floor 3, 2

    #
    # we have not moved the elevators so the requested floors should be queued
    #
    assert_equal [], elevator_controller.sorted_elevators[0].requested_floors
    assert_equal [1,4,4], elevator_controller.sorted_elevators[1].requested_floors
    assert_equal [3], elevator_controller.sorted_elevators[2].requested_floors
    assert_equal [5], elevator_controller.sorted_elevators[3].requested_floors
  end

  test "should move elevators" do
    elevator_controller = ElevatorController.create(floors: 7, elevator_count: 4) # from 0 to 6
    elevator_controller.elevator_go_to_floor 1, 1
    elevator_controller.elevator_go_to_floor 4, 1
    elevator_controller.elevator_go_to_floor 5, 3
    elevator_controller.elevator_go_to_floor 4, 1
    elevator_controller.elevator_go_to_floor 3, 2

    # all this methods execute work
    #
    elevator_controller.request_down 3
    elevator_controller.request_up 3
    elevator_controller.request_up 1
    elevator_controller.request_up 5
    elevator_controller.request_down 6
    elevator_controller.work
    assert_equal 1, elevator_controller.sorted_elevators[0].current_floor
    assert_equal 6, elevator_controller.sorted_elevators[1].current_floor
    assert_equal 3, elevator_controller.sorted_elevators[2].current_floor
    assert_equal 5, elevator_controller.sorted_elevators[3].current_floor
  end

  test "should mantain a list of floor numbers" do
    elevator_controller = ElevatorController.create(floors: 7, elevator_count: 4) # from 0 to 6

    # this method execute work and moves elevator 0 to floor 1
    #
    elevator_controller.request_down 1

    # this methos don't execute work. just queue requested floors in elevators 2,3,1 and 0
    #
    elevator_controller.elevator_go_to_floor 4, 2
    elevator_controller.elevator_go_to_floor 5, 2
    elevator_controller.elevator_go_to_floor 4, 3
    elevator_controller.elevator_go_to_floor 3, 1
    elevator_controller.elevator_go_to_floor 6, 0
    elevator_controller.elevator_go_to_floor 0, 0

    #
    # move elevator three times
    #
    elevator_controller.work
    elevator_controller.work
    elevator_controller.work

    #
    # requested_floors list must be updated
    #
    assert_equal [6,0], elevator_controller.sorted_elevators[0].requested_floors
    assert_equal [], elevator_controller.sorted_elevators[1].requested_floors
    assert_equal [4,5], elevator_controller.sorted_elevators[2].requested_floors

    #
    # this elevator should be in its way to floor 4
    #
    assert_equal 3, elevator_controller.sorted_elevators[3].current_floor
    assert_equal [4], elevator_controller.sorted_elevators[3].requested_floors
  end

end
