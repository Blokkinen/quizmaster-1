class GamesController < ApplicationController
  before_action :get_quiz, only: [:show]

  def index
  end

  def show
    @team = Team.find(cookies['team_id']) unless cookies['team_id'].nil?
    render :show, locals: {message: "Welcome to quiz: #{@quiz.name}"}
  end

  def access_quiz
    quiz = Quiz.find_by(code: params[:code])
    if quiz.nil?
      flash.now[:notice] = "Invalid code. Talk to your Quizmaster."
      render :index
    else
      redirect_to quiz_path(quiz)
    end
  end

  def create_team
    team = Team.create(name: params[:team][:name], quiz_id: params[:quiz_id])
    quiz = Quiz.find(params[:quiz_id])
    cookies['team_id'] = team.id
    cookies['quiz_id'] = quiz.id
    redirect_to quiz_path(quiz)
  end

  private
  def get_quiz
    @quiz = Quiz.find(params[:id])
  end

end
