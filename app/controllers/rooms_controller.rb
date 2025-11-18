class RoomsController < ApplicationController
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def index
    @rooms = Room.all
  end

  def show
    @room = Room.find_by!(code: params[:id])
  end

  def create
    @room = Room.new(room_params)

    if @room.save
      redirect_to rooms_path, notice: "Room '#{@room.name}' was created successfully with code #{@room.code}!"
    else
      @rooms = Room.all
      flash.now[:alert] = "Failed to create room: #{@room.errors.full_messages.join(', ')}"
      render :index, status: :unprocessable_entity
    end
  end

  private

  def room_params
    params.permit(:name)
  end
end
