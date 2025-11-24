class QuestionResponses::ReactionsController < ApplicationController
  def create
    @question_response = QuestionResponse.find(params[:question_response_id])
    @reaction = @question_response.response_reactions.build(session_id: current_session_id)

    if @reaction.save
      broadcast_update
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def destroy
    @question_response = QuestionResponse.find(params[:question_response_id])
    @reaction = @question_response.response_reactions.find_by(session_id: current_session_id)

    if @reaction&.destroy
      broadcast_update
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private

  def broadcast_update
    RoomChannel.broadcast_to(@question_response.room, {
      type: "reaction_update",
      question_response_id: @question_response.id,
      count: @question_response.response_reactions.count
    })
  end
end
