class ElevatorsController < ApplicationController

  def index
    @elevators = Elevator.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @elevators }
    end
  end

  def show
    @elevator = Elevator.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @elevator }
    end
  end

  def new
    @elevator = Elevator.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @elevator }
    end
  end

  def edit
    @elevator = Elevator.find(params[:id])
  end

  def create
    @elevator = Elevator.new(elevator_params)

    respond_to do |format|
      if @elevator.save
        format.html { redirect_to elevators_path, notice: 'Elevator was successfully created.' }
        format.json { render json: @elevator, status: :created, location: elevators_path }
      else
        format.html { render action: "new" }
        format.json { render json: @elevators.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @elevator = Elevator.find(params[:id])

    respond_to do |format|
      if @elevator.update_attributes(elevator_params)
        format.html { redirect_to elevators_path, notice: 'Elevator was successfully updated.' }
        format.json { head :no_content }
      else
        flash[:error] = @elevator.errors.messages.to_a.join("\n")
        format.html { render action: "edit" }
        format.json { render json: @elevator.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @elevator = Elevator.find(params[:id])
    @elevator.destroy

    respond_to do |format|
      format.html { redirect_to elevators_url }
      format.json { head :no_content }
    end
  end

  def request_up
    @elevator = Elevator.find(params[:id])
    @elevator.request_up(params[:floor])
    redirect_to action: "show"
  end

  def request_down
    @elevator = Elevator.find(params[:id])
    @elevator.request_down(params[:floor])
    redirect_to action: "show"
  end

  def go_to_floor
    @elevator = Elevator.find(params[:id])
    @elevator.go_to_floor(params[:floor])
    redirect_to action: "show"
  end

  def show_default_elevator
    elevator = Elevator.first
    if elevator.present?
      redirect_to action: "show", id: elevator.id
    end
  end

  # this method should move the elevator if need on floor in every call in
  # self.direction
  #
  def work
    @elevator = Elevator.find(params[:id])
    @elevator.work
    redirect_to action: "show"
  end

  private

  def elevator_params
    params.require(:elevator).permit(:floors)
  end

end