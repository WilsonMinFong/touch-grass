class RoomsController < ApplicationController
  def index
    @rooms = Room.for_session(current_session_id)
  end

  def show
    @room = Room.find_by!(code: params[:id])
    @room.join_session(current_session_id)
    @is_owner = @room.is_owner?(current_session_id)

    if @room.completed?
      redirect_to responses_room_path(@room)
      return
    end

    # Ensure current question is set
    unless @room.current_question
      @room.update(current_question: Question.order(:id).first)
    end
    @current_question = @room.current_question

    # Check if user has answered the current question
    @has_answered = @room.question_responses.exists?(
      question: @current_question,
      session_id: current_session_id
    )

    if @has_answered
      # Prepare variables for responses view (scoped to current question)
      @responses = @room.question_responses
                        .where(question: @current_question)
                        .includes(:response_reactions)
      @liked_response_ids = @room.question_responses
                                 .joins(:response_reactions)
                                 .where(response_reactions: { session_id: current_session_id })
                                 .pluck(:id)
                                 .to_set
      @current_author_token = Digest::SHA256.hexdigest(current_session_id)
    end
  end

  def next_question
    @room = Room.find_by!(code: params[:id])

    unless @room.is_owner?(current_session_id)
      head :forbidden
      return
    end

    @room.next_question!

    RoomChannel.broadcast_to(@room, {
      type: "next_question",
      question_id: @room.current_question&.id
    })

    redirect_to room_path(@room)
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
    @room = Room.new(room_params.merge(
      session_id: current_session_id,
      current_question: Question.order(:id).first
    ))

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
