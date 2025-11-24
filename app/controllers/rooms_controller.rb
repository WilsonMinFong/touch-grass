class RoomsController < ApplicationController
  def index
    @rooms = Room.for_session(current_session_id)
  end

  def show
    @room = Room.find_by!(code: params[:id])  # Allow viewing any room by code
    @room.join_session(current_session_id)    # Automatically join when viewing
    @is_owner = @room.is_owner?(current_session_id)

    # Load all questions and user's responses in one query
    @questions = Question.all
    @user_responses = @room.question_responses
                          .where(session_id: current_session_id)
                          .index_by(&:question_id)
  end

  def responses
    @room = Room.find_by!(code: params[:id])
    @questions = Question.all
    @responses_by_question = @room.question_responses.includes(:question, :response_reactions).group_by(&:question_id)
    @liked_response_ids = @room.question_responses
                               .joins(:response_reactions)
                               .where(response_reactions: { session_id: current_session_id })
                               .pluck(:id)
                               .to_set
    @current_author_token = Digest::SHA256.hexdigest(current_session_id)
  end

  def create
    @room = Room.new(room_params.merge(session_id: current_session_id))

    if @room.save
      redirect_to rooms_path, notice: "Room '#{@room.name}' was created successfully with code #{@room.code}!"
    else
      @rooms = Room.for_session(current_session_id)
      flash.now[:alert] = "Failed to create room: #{@room.errors.full_messages.join(', ')}"
      render :index, status: :unprocessable_entity
    end
  end

  def join
    @room = Room.find_by!(code: params[:id])
    @room.join_session(current_session_id)
    redirect_to room_path(@room), notice: "You joined #{@room.name}!"
  end

  def leave
    @room = Room.find_by!(code: params[:id])
    @room.leave_session(current_session_id)
    redirect_to rooms_path, notice: "You left #{@room.name}"
  end

  def join_by_code
    @room = Room.find_by(code: params[:code].upcase)
    if @room
      redirect_to room_path(@room)
    else
      redirect_to rooms_path, alert: "Room not found with code: #{params[:code]}"
    end
  end

  def heartbeat
    @room = Room.find_by!(code: params[:id])
    presence = @room.join_session(current_session_id)
    render json: {
      participants_count: @room.active_participants_count,
      last_seen: presence.last_seen
    }
  end

  private

  def room_params
    params.permit(:name)
  end
end
