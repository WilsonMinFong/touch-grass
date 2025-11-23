class QuestionResponsesController < ApplicationController
  def index
    @room = Room.find_by!(code: params[:room_id])
    question_id = params[:question_id]
    response = @room.question_responses.find_by(
      session_id: current_session_id,
      question_id: question_id
    )

    render json: { response: response }
  end

  def create
    @room = Room.find_by!(code: params[:room_id])
    question_response = @room.question_responses.build(question_response_params)
    question_response.session_id = current_session_id

    if question_response.save
      RoomChannel.broadcast_to(@room, {
        type: "new_response",
        question_id: question_response.question_id,
        response_text: question_response.response_text,
        response_id: question_response.id
      })

      all_answered = @room.question_responses.where(session_id: current_session_id).count >= Question.count

      render json: {
        success: true,
        message: "Response saved successfully!",
        response: question_response,
        all_answered: all_answered
      }
    else
      render json: {
        success: false,
        error: question_response.errors.full_messages.join(", ")
      }, status: :unprocessable_entity
    end
  end

  def update
    @room = Room.find_by!(code: params[:room_id])
    question_response = QuestionResponse.find_by!(id: params[:id], session_id: current_session_id)

    if question_response.update(question_response_params)
      RoomChannel.broadcast_to(@room, {
        type: "new_response",
        question_id: question_response.question_id,
        response_text: question_response.response_text,
        response_id: question_response.id
      })

      # For update, we assume they already answered everything or are just editing one,
      # but we can still return the status.
      all_answered = @room.question_responses.where(session_id: current_session_id).count >= Question.count

      render json: {
        success: true,
        message: "Response saved successfully!",
        response: question_response,
        all_answered: all_answered
      }
    else
      render json: {
        success: false,
        error: question_response.errors.full_messages.join(", ")
      }, status: :unprocessable_entity
    end
  end

  private

  def question_response_params
    params.permit(:question_id, :response_text)
  end
end
