class Api::V1::AnswersController < Api::BaseController

  # body = the answer | params: {body: "the answer"}
  # answer[body] = the answer | params: {answer: {body:"the answer"}}

  def create
    question          = Question.find params[:question_id]
    answer            = Answer.new answer_params
    answer.question   = question
    answer.user       = @user
    answer.save
    render json: {success: true}
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def authenticate_api_user
    user = User.find_by_api_key params[:api_key]
    head :forbidden unless user
  end

end
