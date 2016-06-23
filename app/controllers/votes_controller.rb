class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    vote = Vote.new vote_params
    vote.user = current_user
    vote.question = current_question
    if vote.save
      redirect_to current_question, notice: "Thanks for voting"
    else
      redirect_to current_question, alert: "Error occurred"
    end
  end

  def destroy
    vote = Vote.find params[:id]
    if vote
      vote.destroy
      redirect_to current_question, notice: "Vote removed"
    else
      redirect_to current_question
    end
  end

  def update
    vote = Vote.find params[:id]
    if vote
      vote.update(vote_params)
      redirect_to current_question, notice: "Vote changed"
    else
      redirect_to current_question
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:is_up)
  end
end
