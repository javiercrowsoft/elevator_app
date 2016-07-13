class ElevatorControllersController < ApplicationController

  def index
    @elevator_controllers = ElevatorController.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @elevator_controllers }
    end
  end

  def show
    @elevator_controller = ElevatorController.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @elevator_controller }
    end
  end

  def new
    @elevator_controller = ElevatorController.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @elevator_controller }
    end
  end

  def edit
    @elevator_controller = ElevatorController.find(params[:id])
  end

  def create
    @elevator_controller = ElevatorController.new(elevator_controller_params)

    respond_to do |format|
      if @elevator_controller.save
        format.html { redirect_to elevator_controllers_path, notice: 'Elevator was successfully created.' }
        format.json { render json: @elevator_controller, status: :created, location: elevators_path }
      else
        format.html { render action: "new" }
        format.json { render json: @elevator_controllers.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @elevator_controller = ElevatorController.find(params[:id])

    respond_to do |format|
      if @elevator_controller.update_attributes(elevator_controller_params)
        format.html { redirect_to elevator_controllers_path, notice: 'Elevator was successfully updated.' }
        format.json { head :no_content }
      else
        flash[:error] = @elevator_controller.errors.messages.to_a.join("\n")
        format.html { render action: "edit" }
        format.json { render json: @elevator_controller.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @elevator_controller = ElevatorController.find(params[:id])
    @elevator_controller.destroy

    respond_to do |format|
      format.html { redirect_to elevator_controllers_url }
      format.json { head :no_content }
    end
  end

  def request_up
    @elevator_controller = ElevatorController.find(params[:id])
    @elevator_controller.request_up(params[:floor])
    redirect_to action: "show"
  end

  def request_down
    @elevator_controller = ElevatorController.find(params[:id])
    @elevator_controller.request_down(params[:floor])
    redirect_to action: "show"
  end

  def elevator_go_to_floor
    @elevator_controller = ElevatorController.find(params[:id])
    @elevator_controller.elevator_go_to_floor(params[:floor], params[:elevator])
    redirect_to action: "show"
  end

  def show_default_elevator_controller
    elevator_controller = ElevatorController.first
    if elevator_controller.present?
      redirect_to action: "show", id: elevator_controller.id
    else
      redirect_to action: "index"
    end
  end

  # this method should move the elevator if need on floor in every call in
  # self.direction
  #
  def work
    @elevator_controller = ElevatorController.find(params[:id])
    @elevator_controller.work
    redirect_to action: "show"
  end

  private

  def elevator_controller_params
    params.require(:elevator_controller).permit(:floors, :elevator_count)
  end

end