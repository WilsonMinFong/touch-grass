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
      render json: {
        success: true,
        message: "Response saved successfully!",
        response: question_response
      }
    else
      render json: {
        success: false,
        error: question_response.errors.full_messages.join(", ")
      }, status: :unprocessable_entity
    end
  end

  def update
    question_response = QuestionResponse.find_by!(id: params[:id], session_id: current_session_id)

    if question_response.update(question_response_params)
      render json: {
        success: true,
        message: "Response saved successfully!",
        response: question_response
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
